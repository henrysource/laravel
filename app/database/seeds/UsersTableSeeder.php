<?php

class UsersTableSeeder extends Seeder
{
    public function run()
    {
        // Create Admins
        $adminGroup = Sentry::getGroupProvider()->findByName('admin');

        Sentry::register(array(
                'first_name' => 'Super',
                'last_name' => 'User',
                'email' => 'superuser@example.com',
                'password' => 'password',
                'permissions' => array(
                    'superuser' => 1
                )
        ), true)->addGroup($adminGroup);

        Sentry::register(array(
                'first_name' => 'Thomas',
                'last_name' => 'Welton',
                'email' => 'thomas.welton@helloworldlondon.co.uk',
                'password' => substr(md5(uniqid()), 0, 16),
                'permissions' => array(
                    'superuser' => 1
                )
        ), true)->addGroup($adminGroup);

        Sentry::register(array(
                'first_name' => 'Thomas',
                'last_name' => 'Welton',
                'email' => 'david.thingsaker@helloworldlondon.co.uk',
                'password' => substr(md5(uniqid()), 0, 16),
                'permissions' => array(
                    'superuser' => 1
                )
        ), true)->addGroup($adminGroup);

        // Create Admins

        Sentry::register(array(
                'first_name' => 'Rod',
                'last_name' => 'Pereira',
                'email' => 'rod.pereira@helloworldlondon.co.uk',
                'password' => substr(md5(uniqid()), 0, 16)
        ), true)->addGroup($adminGroup);

        Sentry::register(array(
                'first_name' => 'Jose',
                'last_name' => 'Galan',
                'email' => 'jose.galan@helloworldlondon.co.uk',
                'password' => substr(md5(uniqid()), 0, 16)
        ), true)->addGroup($adminGroup);

        Sentry::register(array(
                'first_name' => 'Sanjay',
                'last_name' => 'Vadher',
                'email' => 'sanjay.vadher@helloworldlondon.co.uk',
                'password' => substr(md5(uniqid()), 0, 16)
        ), true)->addGroup($adminGroup);

        Sentry::register(array(
                'first_name' => 'Admin',
                'last_name' => 'User',
                'email' => 'admin@example.com',
                'password' => 'password'
        ), true)->addGroup($adminGroup);

        // Create Users
        $userGroup = Sentry::getGroupProvider()->findByName('user');

        $user = Sentry::register(array(
                'first_name' => 'Example',
                'last_name' => 'User',
                'email' => 'user@example.com',
                'password' => 'password'
        ), true)->addGroup($userGroup);
    }
}
