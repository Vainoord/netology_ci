# Самоконтроль выполненения задания

1. Где расположен файл с `some_fact` из второго пункта задания?

   Файл расположен в директории `playbook/group_vars/all`

2. Какая команда нужна для запуска вашего `playbook` на окружении `test.yml`?

   ```{bash}
   ansible-playbook playbook/site.yml -i playbook/inventory/test.yml
   ```

3. Какой командой можно зашифровать файл?

   `ansible-vault encrypt /path/to/file`
4. Какой командой можно расшифровать файл?

   `ansible-vault decrypt /path/to/file`

5. Можно ли посмотреть содержимое зашифрованного файла без команды расшифровки файла? Если можно, то как?

   Можно. `ansible-vault view /path/to/file`

6. Как выглядит команда запуска `playbook`, если переменные зашифрованы?

   `ansbible-playbook /path/to/playbook.yml /path/to/inventory.yml --ask-vault-pass`

7. Как называется модуль подключения к host на windows?

   Есть два модуля. `pspr` для запуска тасков через powershell и `winrm` для запуска тасков через WinRM.

8. Приведите полный текст команды для поиска информации в документации ansible для модуля подключений ssh

   Скорее всего командой `ansible-doc -t connection -s ssh`. Но в моем случае это не работает:

   ```{bash}
   21:59:41 | ~/netology/netology_ci [main]
   \(vainoord) $> ansible-doc -t connection -s ssh
   ERROR! Snippets are only available for the following plugin types: inventory, lookup, module
   ```

9. Какой параметр из модуля подключения `ssh` необходим для того, чтобы определить пользователя, под которым необходимо совершать подключение?

   `remote_user`