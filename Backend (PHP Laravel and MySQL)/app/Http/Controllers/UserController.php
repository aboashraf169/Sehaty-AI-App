<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;

class UserController extends Controller
{
    public function doctors(){
        $doctors = User::query()->where("is_doctor" , true)->with('specialty')->paginate(10);
        return response()->json($doctors);
    }

    public function paients(){
        $paients = User::query()->where("is_doctor" , false)->paginate(10);
        return response()->json($paients);
    }

    public function doctorPaients(Request $request){

        $paients = $request->user("sanctum")->doctorPaients()->paginate(10);
        return response()->json($paients);
    }

    public function paientDoctors(Request $request){

        $doctors = $request->user()->paientDoctors()->paginate(10);
        return response()->json($doctors);
    }


    public function followDoctor(Request $request, $id)
    {
        $doctor = User::whereId($id)->where('is_doctor' , true)->exists();

        if (!$doctor) {
            return response()->json(['message' => 'Doctor not found'], 404);
        }

        $following = $request->user('sanctum')->toggleFollowDoctor($id);

        return response()->json([
            'message' => $following ? 'Doctor followed successfully' : 'Doctor unfollowed successfully',
            'following' => $following, // Indicate whether the user is now following the doctor
        ]);
    }

}
