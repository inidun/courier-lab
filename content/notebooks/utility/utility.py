import gzip
import io
import json
import os
import zipfile
from pathlib import Path
from typing import Literal

from js import fetch
from pyodide.http import pyfetch

DATA_URL = "https://raw.githubusercontent.com/inidun/courier-lab/main/data"


async def download_nltk(package: str, filename: str = None):
    nltk_data: str = os.environ.get("NLTK_DATA", None) or "/nltk_data"

    response = await fetch(f"https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/{package}/{filename}")

    js_buffer = await response.arrayBuffer()
    py_buffer = js_buffer.to_py()
    stream = py_buffer.tobytes()

    package_folder: str = Path(f"{nltk_data}/{package}")
    package_folder.mkdir(parents=True, exist_ok=True)

    Path(f"{package_folder}/{filename}").write_bytes(stream)

    # extract punkt.zip
    zipfile.ZipFile(f"{package_folder}/{filename}").extractall(path=f"{package_folder}/")

    # check file contents in /nltk_data/tokenizers/
    # print(os.listdir("/nltk_data/tokenizers/punkt"))


async def download_to_folder(folder: str, tag: str) -> None:
    download_binary_to_folder(folder, tag, "token2id.json.gz")
    download_binary_to_folder(folder, tag, "document_index.csv.gz")
    download_binary_to_folder(folder, tag, "vector_data.npz")


async def download_binary_to_folder(tag: str, suffix: str, folder: str) -> bytes:
    url: str = f"{DATA_URL}/dtm/{tag}/{tag}_{suffix}"
    data: bytes = download_data(url, kind="binary", compression="None")
    with open(f"{folder}/{tag}/{tag}_{suffix}", "wb") as fp:
        os.makedirs(f"{folder}/{tag}", exist_ok=True)
        fp.write(data)


async def download_data(
    url: str,
    kind: Literal["json", "text", "binary"],
    compression: Literal["None", "gzip"],
) -> dict | str | bytes | None:
    """Download data from url and return it as json, text or binary."""
    response = await pyfetch(url)
    if not response.ok:
        return None

    if kind == "binary" or compression != "None":
        data: bytes = await response.bytes()
    else:
        data: str = await response.string()

    if compression == "gzip":
        decompressed = gzip.GzipFile(fileobj=data, mode="rb")
        data: bytes = decompressed.read()

    if kind == "json":
        return json.loads(io.BytesIO(data).read().decode("utf-8"))

    if kind == "text":
        if isinstance(data, bytes):
            return data.decode("utf-8")

    return data
