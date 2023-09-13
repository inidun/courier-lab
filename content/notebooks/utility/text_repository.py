from penelope.corpus import render
import pandas as pd

class TextRepository(render.TextRepository):
    def __init__(
        self,
        *,
        source: str | render.Loader,
        document_index: pd.DataFrame,
        transforms: str = "normalize-whitespace",
        filenames: str = None,
    ):
        # FIXME
        super().__init__(source=source, document_index=document_index, transforms=transforms)
        self.pdf_filenames: dict[str, str] = pd.read_csv(filenames, sep=',', index_col=0)['filename'].to_dict()

    def _get_info(self, document_name: str) -> dict:
        data: dict = super()._get_info(document_name)
        data['pdf_filename'] = self.pdf_filenames.get(int(document_name.split('_')[1]))
        return data
