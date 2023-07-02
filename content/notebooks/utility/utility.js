window.saveJSONP = async (urlString, file_path, mime_type='text/json', binary=false) => {
    const sc = document.createElement('script');
    var url = new URL(urlString);
    url.searchParams.append('callback', 'window.corsCallBack');
    
    sc.src = url.toString();

    window.corsCallBack = async (data) => {
        console.log(data);

        // Open (or create) the file storage
        var open = indexedDB.open('JupyterLite Storage');

        // Create the schema
        open.onupgradeneeded = function() {
            throw Error('Error opening IndexedDB. Should not ever need to upgrade JupyterLite Storage Schema');
        };

        open.onsuccess = function() {
            // Start a new transaction
            var db = open.result;
            var tx = db.transaction("files", "readwrite");
            var store = tx.objectStore("files");

            var now = new Date();

            var value = {
                'name': file_path.split(/[\\/]/).pop(),
                'path': file_path,
                'format': binary ? 'binary' : 'text',
                'created': now.toISOString(),
                'last_modified': now.toISOString(),
                'content': JSON.stringify(data),
                'mimetype': mime_type,
                'type': 'file',
                'writable': true
            };      

            const countRequest = store.count(file_path);
            countRequest.onsuccess = () => {
              console.log(countRequest.result);
                if(countRequest.result > 0) {
                    store.put(value, file_path);
                } else {
                    store.add(value, file_path);
                }   
            }; 

            // Close the db when the transaction is done
            tx.oncomplete = function() {
                db.close();
            };
        }
    }

    document.getElementsByTagName('head')[0].appendChild(sc);
}
