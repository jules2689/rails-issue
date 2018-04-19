# Issue demonstration

[This commit](https://github.com/rails/rails/commit/68fe6b08ee72cc47263e0d2c9ff07f75c4b42761) was intended to fix an issue with casting.

However, it seems that, with MySQL this issue continues to occur. In the octobox app, I get

```
NotificationsControllerTest#test_archives_respects_current_filters:
ActiveRecord::StatementInvalid: Mysql2::Error: Truncated incorrect DOUBLE value: 'true': UPDATE `notifications` SET `notifications`.`archived` = TRUE WHERE `notifications`.`user_id` = 7 AND `notifications`.`archived` = FALSE AND `notifications`.`unread` = 'true'
    app/controllers/notifications_controller.rb:135:in `archive_selected'
    test/controllers/notifications_controller_test.rb:198:in `block in <class:NotificationsControllerTest>'
```

To see the issue, start your mysql server and run `ruby bug_mysql.rb`. `ruby bug_sqlite.rb` shows a different one, and `ruby bug_postgres.rb` works entirely.

The tests illustrate the issue