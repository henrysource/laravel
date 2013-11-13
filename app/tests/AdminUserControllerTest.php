<?php

use Zizaco\FactoryMuff\Facade\FactoryMuff;

class AdminUserControllerTest extends TestCase
{
    public function testUserIndexPage()
    {
        $this->client->request('GET', 'admin/users');
        $this->assertTrue($this->client->getResponse()->isOk());
    }

    public function testUserCsvDownload()
    {
        FactoryMuff::create('User');

        $this->client->request('GET', 'admin/users?&format=csv');
        $this->assertTrue($this->client->getResponse()->isOk());
    }

    public function testUserCreatePage()
    {
        $this->client->request('GET', 'admin/users/create');
        $this->assertTrue($this->client->getResponse()->isOk());
    }

    public function testUserEditPage()
    {
        $user = FactoryMuff::create('User');

        $this->client->request('GET', "admin/users/{$user->id}/edit");
        $this->assertTrue($this->client->getResponse()->isOk());
    }

    public function testEditNonExistantUserRedirectsToUserList()
    {
        $this->client->request('GET', "admin/users/1/edit");
        $this->assertRedirectedTo('admin/users');
    }

    public function testUserEditFillsFormWithData()
    {
        $user = FactoryMuff::create('User');

        $this->client->request('GET', "admin/users/{$user->id}/edit");
        $this->assertTrue($this->client->getResponse()->isOk());

        $this->assertViewHas('user');
    }

    public function testDeleteUser()
    {
        $user = FactoryMuff::create('User');

        // Check redirect back to list view
        $this->client->request('DELETE', "admin/users/{$user->id}");
        $this->assertRedirectedTo('admin/users');

        $deletedUser = User::find($user->id);

        $this->assertNull($deletedUser);
    }

    public function testRestoreUser()
    {
        $user = FactoryMuff::create('User');
        $user->delete();

        // Check redirect back to list view
        $this->client->request('POST', "admin/users/restore/{$user->id}");
        $this->assertRedirectedTo('admin/users');
    }

}
