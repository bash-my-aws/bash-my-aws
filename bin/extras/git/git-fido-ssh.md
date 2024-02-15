# Setting up 2 FIDO2 SSH keys for GitHub

Keep work and personal GitHub accounts separate by using FIDO2 SSH keys.

## Setup FIDO2 SSH keys for GitHub Work Context

```shell
$ git-fido-ssh x1@github-work
Generating public/private ecdsa-sk key pair.
You may need to touch your authenticator to authorize key generation.
Enter PIN for authenticator: 
You may need to touch your authenticator (again) to authorize key generation.
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/m/.ssh/x1@github-work
Your public key has been saved in /home/m/.ssh/x1@github-work.pub
The key fingerprint is:
SHA256:XnBB5eyL23j68kXqwqMd22YnWs5XmeIc3WVhIIgHz2Y x1@github-work
The key's randomart image is:
+-[ECDSA-SK 256]--+
|       .o.+o...  |
|       .oo +.  o |
|        oE. o . .|
|        oo .    o|
|        S . . o.=|
|       . . . * +o|
|        ..o * +. |
|         .=%=+o  |
|        ..B%O+   |
+----[SHA256]-----+
SSH key generated at /home/m/.ssh/x1@github-work
Agent pid 174794
Identity added: /home/m/.ssh/x1@github-work (x1@github-work)
  ✓ Logged in to github.com as mbailey-versent (keyring)
Do you want to continue with this account? (y/n) y
✓ Public key added to your account
Git and SSH setup complete for realm: github-work
```

```shell
$ ssh -T git@github-personal
Hi mbailey! You've successfully authenticated, but GitHub does not provide shell access.
```

## Setup FIDO2 SSH keys for GitHub Personal Context

```shell
$ git-fido-ssh x1@github-personal
Generating public/private ecdsa-sk key pair.
You may need to touch your authenticator to authorize key generation.
Enter PIN for authenticator: 
You may need to touch your authenticator (again) to authorize key generation.
PIN incorrect
Enter PIN for authenticator: 
You may need to touch your authenticator (again) to authorize key generation.
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/m/.ssh/x1@github-personal
Your public key has been saved in /home/m/.ssh/x1@github-personal.pub
The key fingerprint is:
SHA256:MMQJvIYViB54KtoVE9QFxOhJ3wC7+xU1gpGhc9rUOm4 x1@github-personal
The key's randomart image is:
+-[ECDSA-SK 256]--+
|.. +*@**.        |
|o.o B+B+         |
|.o.=+**oo o      |
|o.. *B.+.o .     |
|o. oo + S        |
|. .  o . .       |
|    . E .        |
|     o .         |
|      .          |
+----[SHA256]-----+
SSH key generated at /home/m/.ssh/x1@github-personal
Agent pid 174862
Identity added: /home/m/.ssh/x1@github-personal (x1@github-personal)
  ✓ Logged in to github.com as mbailey-versent (keyring)
Do you want to continue with this account? (y/n) n
Logging out...
✓ Logged out of github.com account 'mbailey-versent'
Please log in to the correct GitHub account.
? What account do you want to log into? GitHub.com
? What is your preferred protocol for Git operations? SSH
? Upload your SSH public key to your GitHub account? /home/m/.ssh/x1@github-personal.pub
? Title for your SSH key: x1@github-personal
? How would you like to authenticate GitHub CLI? Login with a web browser

! First copy your one-time code: 846E-D799
Press Enter to open github.com in your browser... 
✓ Authentication complete.
- gh config set -h github.com git_protocol ssh
✓ Configured git protocol
✓ Uploaded the SSH key to your GitHub account: /home/m/.ssh/x1@github-personal.pub
✓ Logged in as mbailey
✓ Public key already exists on your account
Git and SSH setup complete for realm: github-personal
```

```shell
$ ssh -T git@github-work
Hi mbailey-work! You've successfully authenticated, but GitHub does not provide shell access.
```
