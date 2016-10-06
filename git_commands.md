* local user name

```
git config user.name "Jeong Han Lee"
git config user.email "jeonghan.lee@gmail.com"
```

* Only one type in your id and password, and they are valid during 3600s (1h)
```
git config --global credential.helper 'cache --timeout=3600'
```
