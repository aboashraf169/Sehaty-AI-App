<?php

namespace App\Models;

use App\Models\Specialty;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Builder;

class Article extends Model
{
    protected $guarded = [];

    public function doctor(){
        return $this->belongsTo(User::class);
    }

    public static function ScopeGetSpecialtyArticles (Builder $query , $id){

        $query->whereIn("user_id" , Specialty::where('id',$id)->first()->doctors()->get()->pluck('id')->toArray());
    }

    public function comments(){
        return $this->hasMany(Comment::class);
    }




    public function usersSaved(){
        return $this->belongsToMany(User::class , 'user_saved_article' , "article_id" , "user_id");
    }


    public function toggleArticleSave($user_id)
    {
        if ($this->hasSavedArticle($user_id)) {
            $this->usersSaved()->detach($user_id);
        } else {
            $this->usersSaved()->attach($user_id);
        }
    }

    public function hasSavedArticle($user_id)
    {
        // return $this->usersSaved()->wherePivot('user_id', $user_id)->exists();
        return $this->usersSaved()->where('user_id', $user_id)->exists();

    }







    public function usersLiked(){
        return $this->belongsToMany(User::class, 'user_liked_article' , 'article_id' , 'user_id')->withTimestamps();
    }




    public function toggleArticleLike($user_id)
    {
        if ($this->hasLikedArticle($user_id)) {
            $this->usersLiked()->detach($user_id);
        } else {
            $this->usersLiked()->attach($user_id);
        }
    }

    public function hasLikedArticle($user_id)
    {
        return $this->usersLiked()->where('user_id', $user_id)->exists();

    }

}
