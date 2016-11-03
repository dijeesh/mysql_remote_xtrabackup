# mysql_remote_xtrabackup

A simple bash script to push MySQL backups to remote backup vault using Percona Xtrabackup. 


### Instructions to install the script :-

1. Create a working directory for backup scripts
   > mkdir -p /opt/redux/xtrabackup -p

2. Create SSH Key, install SSH key in remote server and confirm SSH access.

   > ssh-keygen -t rsa
   
   > Copy id_rsa.pub to remote server

3. Install Percona Xtabackup

   > wget https://repo.percona.com/apt/percona-release_0.1-4.xenial_all.deb

   > dpkg -i percona-release_0.1-4.xenial_all.deb

   > apt-get update

   > apt-get install percona-xtrabackup-24


4. Create MySQl user for backup

   > mysql> grant all privileges on *.* to MYSQL_USER@'localhost' identified by 'MYSQL_PASSWORD';
   
   > mysql> flush privileges;

5. Install MySQL backup script

   > /opt/redux/xtrabackup/mysql_remote_stream_backup.sh
   
   > chmod +x   /opt/redux/xtrabackup/mysql_remote_stream_backup.sh
    
6. Add a cronjob to run the MySQL backups in 4 hour interval

   > /etc/cron.d/xtrabackup | 01 */4 * * *   /opt/redux/xtrabackup/mysql_remote_stream_backup.sh


To extract Percona XtraBackup‘s archive you must use tar with -i option:

  > tar -xizf backup.tar.gz

Ref : https://www.percona.com/doc/percona-xtrabackup/2.4/installation.html for Installing Percona Xtrabackup on other distros
