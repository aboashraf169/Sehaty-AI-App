<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    /** @use HasFactory<\Database\Factories\UserFactory> */
    use HasFactory, Notifiable, HasApiTokens;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $guarded=[];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
        ];
    }


    public function doctorPaients(){
        return $this->belongsToMany(User::class , 'doctor_paient' , 'doctor_id' , 'paient_id');
    }

    public function paientDoctors(){
        return $this->belongsToMany(User::class , 'doctor_paient' , 'paient_id' , 'doctor_id');
    }

    public function toggleFollowDoctor($doctor_id)
    {
        if ($this->hasFollowingDoctor($doctor_id)) {
            $this->paientDoctors()->detach($doctor_id);
            return false;
        } else {
            $this->paientDoctors()->attach($doctor_id);
            return true;
        }
    }

    public function hasFollowingDoctor($doctor_id)
    {
        return $this->paientDoctors()->where('doctor_id', $doctor_id)->exists();

    }


    public function articles(){
        return $this->hasMany(Article::class);
    }


    public function specialty()
    {
        return $this->belongsToMany(Specialty::class, 'doctor_specialty', 'doctor_id', 'specialty_id')->withTimestamps();
    }

    public function advice(){
        return $this->hasMany(Advice::class , 'doctor_id' );
    }

    public function comments(){
        return $this->hasMany(Comment::class);
    }

    public function savedArticles(){
        return $this->belongsToMany(Article::class , 'user_saved_article' , "user_id" , "article_id");
    }



    public function likedArticles()
    {
        return $this->belongsToMany(Article::class, 'user_liked_article')->withTimestamps();
    }




}
