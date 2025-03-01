<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\Advice;
use App\Rules\MaxWords;
use Illuminate\Http\Request;

class AdviceController extends Controller
{
    public function todayAdvice(Request $request){
        $id = $request->user('sanctum')->id;
        $followingDoctor = User::where('id' , $id)->first()->paientDoctors()->get();
        return Advice::whereIn('doctor_id' , $followingDoctor->pluck('id')->toArray())->postedToday()->paginate(5);
    }

    public function doctorTodayAdvice(Request $request){
        $d_id = $request->user('sanctum')->id;
        return Advice::where('doctor_id' , $d_id)->postedToday()->paginate(5);
    }

    public function store(Request $request){
        $request->validate([
            'advice'=> ['required' , new MaxWords(50)]
        ]);

        $id = $request->user('sanctum')->id;
        $doctor = User::find($id);
        return $doctor->advice()->create(['advice'=>$request['advice']]);
    }

    public function update(Request $request , $id){

        $request->validate([
            'advice' =>'required',
            "id" => "required|exists:advice,id"
        ]);

        $updated = Advice::find($id)->update([
            "advice" => $request->advice
        ]);

        return response()->json($updated?"Updated successfully":"failed update");

    }

    public function destroy(Request $request , $id){

        $request->validate([
            "id"=> "required|exists:advice,id"
        ]);

        $deleted = Advice::find($id)->delete();

        return response()->json($deleted?"Deleted successfully":"failed delete");


    }

}
