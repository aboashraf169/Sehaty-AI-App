<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;

class DoctorSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {

        User::create([
            'name' => "أحمد ماهر الحناوي",
            'email' => "ahmedalhenawi@gmail.com",
            "password" => "123123123",
            "is_doctor" => true,
            "jop_specialty_number" => 405090,
            "bio" => "طبيب مختص في أمراض القلب والشرايين، متاح للاستشارة في جميع الأوقات لعلاج الأمراض المتعلقة بالقلب والأوعية الدموية."
        ]);

        User::create([
            'name' => "سارة عبد الرحمن الصاوي",
            'email' => "sarahalsawy@gmail.com",
            "password" => "123123123",
            "is_doctor" => true,
            "jop_specialty_number" => 405091,
            "bio" => "طبيبة جراحة عامة متخصصة في علاج الحالات الجراحية المختلفة. متاحة للاستشارة في جميع الأوقات لإجراء العمليات الجراحية."
        ]);

        User::create([
            'name' => "محمد إبراهيم عبد السلام",
            'email' => "mohamedabdelsalam@gmail.com",
            "password" => "123123123",
            "is_doctor" => true,
            "jop_specialty_number" => 405092,
            "bio" => "طبيب باطني متخصص في تشخيص وعلاج الأمراض التي تصيب الأعضاء الداخلية للجسم. متاح للاستشارة في جميع الأوقات."
        ]);

        User::create([
            'name' => "ريم خالد الحسيني",
            'email' => "reemalhusseiny@gmail.com",
            "password" => "123123123",
            "is_doctor" => true,
            "jop_specialty_number" => 405093,
            "bio" => "طبيبة جلدية تقدم استشارات تجميلية وعلاجية لأمراض الجلد والشعر. متاحة للاستشارة في جميع الأوقات."
        ]);

        User::create([
            'name' => "علي محمود الشافعي",
            'email' => "alishafee@gmail.com",
            "password" => "123123123",
            "is_doctor" => true,
            "jop_specialty_number" => 405094,
            "bio" => "طبيب متخصص في الأمراض العصبية مع خبرة واسعة في علاج اضطرابات الجهاز العصبي. متاح للاستشارة في جميع الأوقات."
        ]);

        User::create([
            'name' => "ندى أحمد الرفاعي",
            'email' => "nadaalrefaey@gmail.com",
            "password" => "123123123",
            "is_doctor" => true,
            "jop_specialty_number" => 405095,
            "bio" => "طبيبة نفسية متخصصة في علاج الاضطرابات النفسية. تقدم الدعم والعلاج عن بعد. متاحة للاستشارة في جميع الأوقات."
        ]);

        User::create([
            'name' => "يوسف حسن المصري",
            'email' => "yousefalmassry@gmail.com",
            "password" => "123123123",
            "is_doctor" => true,
            "jop_specialty_number" => 405096,
            "bio" => "طبيبة نسائية متخصصة في متابعة الحمل والعقم. متاحة للاستشارة في جميع الأوقات."
        ]);

        User::create([
            'name' => "ليلى سامي النجار",
            'email' => "lailaelnagar@gmail.com",
            "password" => "123123123",
            "is_doctor" => true,
            "jop_specialty_number" => 405097,
            "bio" => "طبيب متخصص في علاج الأورام السرطانية. متاح للاستشارة في جميع الأوقات لمساعدتك في علاج الأورام."
        ]);

        User::create([
            'name' => "عبد الله محمد الغريب",
            'email' => "abdullahalghareeb@gmail.com",
            "password" => "123123123",
            "is_doctor" => true,
            "jop_specialty_number" => 405098,
            "bio" => "طبيب متخصص في جراحة المخ والأعصاب مع خبرة واسعة في معالجة أمراض الجهاز العصبي. متاح للاستشارة في جميع الأوقات."
        ]);

        User::create([
            'name' => "هدى ياسين الشامي",
            'email' => "hudayassine@gmail.com",
            "password" => "123123123",
            "is_doctor" => true,
            "jop_specialty_number" => 405099,
            "bio" => "طبيبة مختصة في طب الأذن والأنف والحنجرة تقدم استشارات لعلاج الأمراض المتعلقة بالأذن والأنف والحنجرة. متاحة للاستشارة في جميع الأوقات."
        ]);


    }
}
