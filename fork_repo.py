#!/usr/bin/env python3
"""
Script to create a fork and setup private repo using GitHub API
"""
import requests
import time
import os
from getpass import getpass

token = os.getenv('GITHUB_TOKEN') or getpass('GitHub Token (PAT, wird nicht angezeigt): ').strip()
if not token:
    raise SystemExit('Kein GitHub Token angegeben. Setze GITHUB_TOKEN oder gib den Token beim Start ein.')
headers = {
    'Authorization': f'token {token}',
    'Accept': 'application/vnd.github.v3+json',
    'User-Agent': 'Python-GitHub-Fork'
}

def api_call(method, endpoint, data=None):
    """Make GitHub API call"""
    url = f'https://api.github.com{endpoint}'
    try:
        if method == 'GET':
            resp = requests.get(url, headers=headers, timeout=10)
        elif method == 'POST':
            resp = requests.post(url, headers=headers, json=data, timeout=10)
        else:
            raise ValueError(f"Unknown method: {method}")
        
        if resp.status_code in [200, 201, 202]:
            return True, resp.json() if resp.text else {}
        else:
            return False, resp.text
    except Exception as e:
        return False, str(e)

def main():
    print("=" * 60)
    print("GitHub Fork & Private Repo Setup")
    print("=" * 60)
    
    # 1. Verify authentication
    print("\n[1/4] Überprüfe Authentifizierung...")
    success, user_data = api_call('GET', '/user')
    if not success:
        print(f"❌ Authentifizierung fehlgeschlagen!")
        print(f"Error: {user_data}")
        return
    
    username = user_data.get('login')
    print(f"✓ Authentifiziert als: {username}")
    
    # 2. Create fork
    print(f"\n[2/4] Erstelle Fork von DragonMaster14545/Infinite-Pixel-Dungeon...")
    success, fork_data = api_call('POST', '/repos/DragonMaster14545/Infinite-Pixel-Dungeon/forks')
    if not success:
        print(f"❌ Fork fehlgeschlagen!")
        print(f"Error: {fork_data}")
        return
    
    fork_full_name = fork_data.get('full_name', '')
    fork_url = fork_data.get('html_url', '')
    print(f"✓ Fork erstellt: {fork_full_name}")
    print(f"  URL: {fork_url}")
    
    # Wait a bit for GitHub to process
    print("\n[3/4] Warte auf GitHub-Verarbeitung (10 Sek)...")
    time.sleep(10)
    
    # 3. Create private repo
    print(f"\n[4/4] Erstelle privates Repo 'InfinitePD NoobModified'...")
    repo_data = {
        'name': 'InfinitePD NoobModified',
        'description': 'Modified fork of Infinite Pixel Dungeon',
        'private': True,
        'has_issues': True,
        'has_projects': True,
        'has_downloads': True
    }
    success, private_repo = api_call('POST', '/user/repos', repo_data)
    if not success:
        print(f"❌ Private Repo fehlgeschlagen!")
        print(f"Error: {private_repo}")
    else:
        private_repo_url = private_repo.get('html_url', '')
        print(f"✓ Privates Repo erstellt: InfinitePD NoobModified")
        print(f"  URL: {private_repo_url}")
    
    # Summary
    print("\n" + "=" * 60)
    print("✓ FERTIG!")
    print("=" * 60)
    print(f"\nFork verfügbar unter:")
    print(f"  https://github.com/{username}/Infinite-Pixel-Dungeon")
    print(f"\nPrivates Repo verfügbar unter:")
    print(f"  https://github.com/{username}/InfinitePD-NoobModified")
    print("\nNächste Schritte:")
    print(f"  1. git remote set-url origin https://github.com/{username}/Infinite-Pixel-Dungeon.git")
    print(f"  2. git push -u origin main (oder aktuellen Branch)")

if __name__ == '__main__':
    main()
