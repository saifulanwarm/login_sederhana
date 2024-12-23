// import 'dart:ffi';

import 'dart:ffi';

import 'package:new_vania/app/models/user.dart';
import 'package:vania/vania.dart';

class UserController extends Controller {
  Future<Response> create(Request req) async {
    req.validate({
      'produk_id':'required',
      'cust_id':'required',
      'nama': 'required|String',
      'alamat': 'required',
      // 'price': 'required',
    }, {
      'cust_id.required': 'ID tidak boleh kosong',
      'nama.required': 'Nama tidak boleh kosong',
      'nama.string': 'Nama tidak boleh angka',
      'alamat.required': 'Deskripsi tidak boleh kosong',
      // 'price.required': 'Harga tidak boleh kosong',
    });

    final dataCustomer = req.input();
    dataCustomer['created_at'] = DateTime.now().toIso8601String();

    final existingUser =
        await User().query().where('nama', '=', dataCustomer['nama']).first();
    if (existingUser != null) {
      return Response.json({
        "message": "Nama sudah ada",
      }, 409);
    }

    await User().query().insert(dataCustomer);

    return Response.json(
      {
        "message": "Success",
        "data": dataCustomer,
      },
      200,
    );
  }

  Future<Response> show() async {
    final dataCustomer = await User().query().get();
    return Response.json({
      'message': 'Success',
      'data': dataCustomer,
    }, 200);
  }

  Future<Response> update(Request req, Char id) async {
  // Validasi input
  req.validate({
    'nama': 'required|String',
    'alamat': 'required',
    // 'price': 'required',
  }, {
    'nama.required': 'Nama tidak boleh kosong',
    'nama.string': 'Nama tidak boleh angka',
    'alamat.required': 'Deskripsi tidak boleh kosong',
    // 'price.required': 'Harga tidak boleh kosong',
  });

  // Mengambil input data produk
  final dataCustomer = req.input();
  dataCustomer['updated_at'] = DateTime.now().toIso8601String(); // Menambahkan updated_at

  // Memeriksa apakah produk dengan cust_id yang diberikan ada
  final existingUser = await User()
      .query()
      .where('cust_id', '=', id) // Pastikan menggunakan 'cust_id' di sini
      .first();

  if (existingUser == null) {
    return Response.json({
      "message": "Produk tidak ditemukan",
    }, 404); // Produk tidak ditemukan
  }

  // Perbarui data produk menggunakan cust_id
  await User()
      .query()
      .where('cust_id', '=', id) // Pastikan menggunakan 'cust_id' untuk update
      .update(dataCustomer);

  return Response.json({
    "message": "Produk berhasil diperbarui",
    "data": dataCustomer,
  }, 200); // Mengembalikan respons sukses
}


  Future<Response> destroy(Char id) async {
    try {
      final product = await User().query().where('cust_id', '=', id).first();

      if (product == null) {
        return Response.json({
          'message': 'Customer dengan ID $id tidak ditemukan',
        }, 404);
      }

      await User().query().where('cust_id', '=', id).delete();
      return Response.json({
        'message': 'Produk berhasil dihapus',
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat menghapus produk',
      }, 500);
    }
  }
}

final UserController userController = UserController();
