<?php

namespace App\Models;

use Carbon\Carbon;
use App\Models\User;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Builder;

class Advice extends Model
{
    protected $guarded =[];

    public function doctor(){
        return $this->belongsTo(User::class , 'doctor_id');
    }

    public function scopePostedToday(Builder $query)
    {
         $query->whereDate('created_at', Carbon::today());
    }
}
