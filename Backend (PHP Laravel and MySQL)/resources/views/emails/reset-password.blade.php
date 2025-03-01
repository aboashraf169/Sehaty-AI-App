<x-mail::message>
# Welcome to Our Application, {{ $user->name }}!

Thank you for registering with us. We are excited to have you on board!

To reset your password, please use the following code:

### Reset Code: **{{ $user->reset_code }}**

If you didn't request this, please ignore this email.

Thanks,<br>
{{ config('app.name') }}
</x-mail::message>
