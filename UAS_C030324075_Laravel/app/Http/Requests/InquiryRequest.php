<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class InquiryRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'category_id' => ['required', 'exists:categories,id'],
            'nama' => ['nullable', 'string'],
            'email' => ['nullable', 'email:rfc'],
            'website' => ['required', 'url'],
            'telp' => ['required', 'numeric'],
            'pesan' => ['required', 'string'],
        ];
    }

    public function messages(): array
    {
        return [
            'email.email' => 'Format email Invalid',
            'website.url' => 'URL tidak valid',
            'telp.numeric' => 'Nomor HP hanya boleh angka',
            'pesan.required' => 'Pesan tidak boleh kosong',
        ];
    }
}
