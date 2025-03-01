<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;

class FollowingDoctorsSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $doctors = User::where("is_doctor" , true)->get();

        $id = 11 ;
        foreach($doctors as $doctor){
            foreach( range($id , $id+5)as $i)
            {
                $doctor->doctorPaients()->attach($id++);
            }

        }
    }
}
