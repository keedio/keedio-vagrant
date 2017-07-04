#!/usr/bin/env python
import os
from urlparse import urlparse

rootdir="/var/www/html/repo/"
print "Syncing Keedio external repositories to local ones."
print "The local repositories will be installed in "+rootdir


def confirm(prompt=None, resp=False):
    """prompts for yes or no response from the user. Returns True for yes and
    False for no.

    'resp' should be set to the default value assumed by the caller when
    user simply types ENTER.

    >>> confirm(prompt='Create Directory?', resp=True)
    Create Directory? [y]|n: 
    True
    >>> confirm(prompt='Create Directory?', resp=False)
    Create Directory? [n]|y: 
    False
    >>> confirm(prompt='Create Directory?', resp=False)
    Create Directory? [n]|y: y
    True

    """
    
    if prompt is None:
        prompt = 'Confirm'

    if resp:
        prompt = '%s [%s]|%s: ' % (prompt, 'y', 'n')
    else:
        prompt = '%s [%s]|%s: ' % (prompt, 'n', 'y')
        
    while True:
        ans = raw_input(prompt)
        if not ans:
            return resp
        if ans not in ['y', 'Y', 'n', 'N']:
            print 'please enter y or n.'
            continue
        if ans == 'y' or ans == 'Y':
            return True
        if ans == 'n' or ans == 'N':
            return False



#Get the list of Keedio repositories. 
command="yum repolist  |cut -c -25| grep keedio"
repos=os.popen(command).read()
repolist=repos.split('\n')
repolist=map(str.strip, repolist)
while '' in repolist:
    repolist.remove('')

for repo in repolist:
	print "Syncing repository ",repo," This will overwrite local repositories\n"
        ans=confirm(prompt="Do you want to continue?", resp=True)  
        print "\n"
        if not ans:
		print "Skipping repo "+repo
                continue
        # This gets URL of a package in the repository
        command='reposync -u -q -r '+str(repo)+' |tail -1'
        url=os.popen(command).read()
        if url == '':
               print "Repository empty, nothing to sync!"
               command="yum -v repolist keedio-1.2-updates | grep Repo-baseurl | cut -c 16-200"
               url=os.popen(command).read()
               url=url.strip()
               print url
        url=urlparse(url)
        path=url.path
        path= os.path.dirname(path)
        
        #We remove the leading / for the join operation
        path=path.strip('/')
        repopath=os.path.join(rootdir,path)
        print repopath 
        command='reposync --norepopath -r '+str(repo)+' -p '+str(repopath)
        try:
            sync=os.popen(command).read() 
            print sync
        except:
            print "!Error in copy of rpms= ",sync
            exit
       
        #updating repo database
        command="createrepo "+str(repopath)
        print command
        try: 
            sync=os.popen(command).read()
            print sync
        except:
            print "!Error in the creation of the repo= ",sync
            exit
