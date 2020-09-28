### パスワードの最小文字数
- password_digest の場合、最小文字数のバリデーションが効かないので、password でバリデーションをかける。
```
has_secure_password

validates :password_digest, presence: true, length: { minimum: 8, allow_blank: true }
# これだとだめ。

validates :password, presence: true, length: { minimum: 8, allow_blank: true }
# これならOK！
```
