<?php

class AdminHomeControllerTest extends TestCase
{
    // Create a new use with optional defination fo attributes
    protected function getAdminUser($attr = array())
    {
        $user = $this->factory->create('User', $attr);

        $adminGroup = Sentry::getGroupProvider()->create(array(
            'name'        => 'admin',
            'permissions' => array(
                'admin' => 1,
                'users' => 1,
            ),
        ));

        $user->addGroup($adminGroup);

        return $user;
    }

    public function testAdminIndexPage()
    {
        $this->client->request('GET', '/admin');
        $this->assertResponseOk();
    }

    public function testGuestRedirectedToLoginPage()
    {
        Route::enableFilters();

        $this->client->request('GET', '/admin');
        $this->assertRedirectedTo('admin/login');
    }

    public function testLoggedInUserCantViewLoginPage(){
        // Assuming the first use is an admin
        $user = $this->getAdminUser();
        Sentry::login($user);


        $this->client->request('GET', '/admin/login');
        $this->assertRedirectedTo('admin');
    }

    public function testLoginRoute()
    {
        $this->client->request('GET', '/admin/login');
        $this->assertResponseOk();
    }

    public function testLogoutDestroysSession()
    {
        $user = $this->getAdminUser();
        Sentry::login($user);

        // Assert the user was logged in
        $this->assertTrue(Auth::check());

        $this->client->request('GET', '/admin/logout');
        $this->assertRedirectedTo('admin/login');

        // Assert use is now logged out
        $this->assertFalse(Auth::check());
    }

    public function testIncorrectLoginFails()
    {
        $this->client->request('POST', '/admin/login');
        $this->assertRedirectedTo('admin/login');

        $this->assertSessionHas('error');
    }

    public function testCorrectLoginRedirectsAndLogsIn()
    {
        $password = substr(md5(rand()),0,10);
        $user = $this->getAdminUser(array('password' => $password));
        $loginData = array('email' => $user->email, 'password' => $password);

        // Check user is not logged in
        $this->assertFalse(Auth::check());

        // Post the login data and ensure we are redirected
        $this->client->request('POST', '/admin/login', $loginData);
        $this->assertRedirectedTo('admin');

        // Check we are now logged in
        $this->assertTrue(Auth::check());
    }

}
