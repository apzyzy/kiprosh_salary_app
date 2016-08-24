# README

Kiprosh app to send Salary slips to associates.

Setup steps

1) bundle install

2) bin/rails db:create

3) bin/rails db:migrate

4) bin/rails db:seed

5) create `config/settings/development.local.yml`

6) Entry appropriate entry for each of the yaml entry

```
google:
  key:
  secret:

smtp:
  user_name:
  password:
  domain:
  address:
  port:
  host:

delayed_jobs:
  enabled:
```

7) Add one `AdminUser` record from `rails c`.
`AdminUser.create(email: '')`
Note - Only this email will be allowed to login initially.

