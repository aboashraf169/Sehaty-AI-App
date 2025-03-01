<?php

namespace App\Http\Controllers\Auth;


use App\Models\User;
use Illuminate\Support\Str;
use Illuminate\Http\Request;
use App\Mail\ResetPasswordMail;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use function Laravel\Prompts\password;
use App\Http\Requests\Auth\LoginRequest;
use Illuminate\Support\Facades\Password;

use Laravel\Sanctum\PersonalAccessToken;
use App\Http\Requests\Auth\RegisterRequest;

class AuthController extends Controller
{
    public function register(RegisterRequest $request)
    {
        $user = User::create(array_merge($request->except(["is_doctor"]) , ['is_doctor'=> boolval($request['is_doctor'])]));

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'user' => $user,
            'token' => $token,
        ], 201);
    }


    public function login(LoginRequest $request)
{


       $request->authenticate();


        $user = User::where('email' , $request->email)->first();
        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'user' => $user,
            'token' => $token,
        ], 200);
    }

    public function logout(Request $request){
        $request->user()->tokens()->delete();

        return response()->json([
            'message' => 'You have been logged out successfully.',
        ], 200);

    }

    public function forgetPassword(Request $request){

        $request->validate([
            'email' => 'required|email|exists:users,email'
        ]);


        $rand =  random_int(1000 , 9999);

        $user = User::query()->where('email' , $request['email'])->first();
        $user->update(["reset_code" =>$rand]);

        Mail::to($request['email'])->send(new ResetPasswordMail($user->refresh() ));


        return response()->json("we sent email to your mail encluded code change password");

    }


    public function checkCode(Request $request)
    {
        $request->validate([
            'email' => 'required|email|exists:users,email',
            'reset_code' => 'required'
        ]);


        $user = User::where('email', $request->email)->firstOrFail();


        if (is_null($user->reset_code)) {
            return response()->json([
                'message' => 'You do not have a reset code.'
            ], 400);
        }


        if ($request->reset_code != $user->reset_code) {
            return response()->json([
                'message' => 'The reset code is invalid.'
            ], 400);
        }

        $user->reset_code = null;
        $user->save();

        return response()->json([
            'token' => $user->createToken('auth_token')->plainTextToken
        ], 200);
    }



    public function resetPassword(Request $request)
    {
        $request->validate([
            'password' => 'required|confirmed|min:6',
        ]);

        $user = $request->user('sanctum');

        $updated = $user->update([
            'password' => $request['password']
        ]);

        if ($updated) {
            return response()->json([
                'message' => 'Password reset successfully.'
            ], 200);
        } else {
            return response()->json([
                'message' => 'Failed to reset password. Please try again.'
            ], 500);
        }
    }
}
