# F*rget my password

fmp is a stateless password manager.
You feed it with a master password, a host and a per host password of your choice.

# Why use fmp?

It's hard to come up with good passwords. It's even harder to memorize them.
It's even worse when your laptop is stolen and you have to change every single password.
And then the database of a website you use is hacked, and your password compromised.
You need a new one. And again, you need to keep it safe in your brain.

We all want straightforward passwords. fmp is here to help you.

# How to use?

![fmp window](/fmp.png)

You probably don't need a tutorial on how to use this, but here are a few tips.

- your master password should be unique. It is stored in the OSX keychain, and therefore encrypted by the system. It should be safe there.
- the host is, well... the HTTP host or the service
- the password is the password you would normally use for this host.

## Scenario 1: you laptop is stolen

Someone broke into your house, stole your laptop and tablets. You need to change every single password you used.

Change your master key, and you should be alright. The migration process might be a little tedious however, but every generated password will be different, and you only need to remember one new, easy password.

## Scenario 2: your favorite forum is hacked

Your password for this forum is compromised. Just as you would do without this manager, choose a new, easy password for this website, and regenerate.

# License

fmp is available under the GNU/GPLv3 license. Use at your own risk.
