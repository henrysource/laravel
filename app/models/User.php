<?php

use Illuminate\Auth\UserInterface;
use Illuminate\Auth\Reminders\RemindableInterface;

class User extends Eloquent implements UserInterface, RemindableInterface {

	/**
	 * The database table used by the model.
	 *
	 * @var string
	 */
	protected $table = 'users';

	protected $fillable = array('username', 'password', 'email');

	/**
	 * The attributes excluded from the model's JSON form.
	 *
	 * @var array
	 */
	protected $hidden = array('password');

	/**
	 * Get the unique identifier for the user.
	 *
	 * @return mixed
	 */
	public function getAuthIdentifier()
	{
		return $this->getKey();
	}

	/**
	 * Get the password for the user.
	 *
	 * @return string
	 */
	public function getAuthPassword()
	{
		return $this->password;
	}

	/**
	 * Get the e-mail address where password reminders are sent.
	 *
	 * @return string
	 */
	public function getReminderEmail()
	{
		return $this->email;
	}

	/**
	 * Get a validation object for a user
	 */
	public static function validate($input, $ignoreId = null){
        
        $ignoreIdStr = (!is_null($ignoreId)) ? ',' . $ignoreId : '';

		$rules = array(
            'username' => 'Required|Min:3|Max:80|alpha_dash|Unique:users,username'.$ignoreIdStr,
            'email'     => 'Required|Between:3,64|Email|Unique:users,email'.$ignoreIdStr,
            'password'  =>'Required|AlphaNum|Between:4,8'
        );

        return Validator::make($input, $rules);
	}

	public static function destroy($id){

		$currentUser = Auth::user();
		if($id == $currentUser->id){
			throw new Exception("You can not delete yourself", 1);
		}

	   	return parent::destroy($id);
	}

	public function roles(){
        return $this->belongsToMany('Role');
    }

    public function isAdmin(){
    	$roles = $this->roles;

    	foreach ($roles as $role) {
    		if($role->level > 1) return true;
    	}

    	return false;
    }

}