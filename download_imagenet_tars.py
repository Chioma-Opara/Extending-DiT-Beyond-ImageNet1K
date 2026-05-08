import sys
print(sys.path)

import pandas as pd
import requests
import os

df = pd.read_excel('/Users/copara/Downloads/imagenet_synset_summary.xlsx', dtype={'sysnet id': str})
synset_ids = df['sysnet id'].tolist()

save_dir = 'imagenet_tars'
os.makedirs(save_dir, exist_ok=True)

session = requests.Session()
# your authentication handled here
session.headers.update({
    'Cookie': 'PHPSESSID=bb12q7p7tp8291crhs5u52b4k6; __utmc=53782320; __utmz=53782320.1777151612.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); __utma=53782320.2100575019.1777151612.1777151612.1777163536.2'
})

for synset_id in synset_ids:
    url = f'https://image-net.org/data/winter21_whole/{synset_id}.tar'
    response = session.get(url, stream=True)
    if response.status_code == 200:
        filepath = os.path.join(save_dir, f'{synset_id}.tar')
        with open(filepath, 'wb') as f:
            for chunk in response.iter_content(chunk_size=8192):
                f.write(chunk)
        print(f'Downloaded {synset_id}')
    else:
        print(f'Failed {synset_id}: {response.status_code}')