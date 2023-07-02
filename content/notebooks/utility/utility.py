import os
import zipfile
from pathlib import Path

from js import fetch


async def download_nltk(package: str, filename: str = None):
    nltk_data: str = os.environ.get("NLTK_DATA", None) or "/nltk_data"

    response = await fetch(
        f"https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/{package}/{filename}"
    )

    js_buffer = await response.arrayBuffer()
    py_buffer = js_buffer.to_py()
    stream = py_buffer.tobytes()

    d = Path(f"{nltk_data}/{package}")
    d.mkdir(parents=True, exist_ok=True)

    Path(f"{nltk_data}/{package}/{filename}").write_bytes(stream)

    # extract punkt.zip
    zipfile.ZipFile(f"{nltk_data}/{package}/{filename}").extractall(
        path=f"{nltk_data}/{package}/"
    )

    # check file contents in /nltk_data/tokenizers/
    # print(os.listdir("/nltk_data/tokenizers/punkt"))

# await download_nltk(package="tokenizers", filename="punkt.zip")

# nltk.word_tokenize("some text here")
