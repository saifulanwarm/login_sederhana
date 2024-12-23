// import 'dart:ffi';

import 'package:new_vania/app/models/product.dart';
import 'package:vania/vania.dart';

class ProductController extends Controller {
  Future<Response> create(Request req) async {
    req.validate({
      'name': 'required|String',
      'description': 'required',
      'price': 'required',
    }, {
      'name.required': 'Nama tidak boleh kosong',
      'name.string': 'Nama tidak boleh angka',
      'description.required': 'Deskripsi tidak boleh kosong',
      'price.required': 'Harga tidak boleh kosong',
    });

    final dataProduct = req.input();
    // dataProduct['created_at'] = DateTime.now().toIso8601String();

    final existingProduct =
        await Product().query().where('name', '=', dataProduct['name']).first();
    if (existingProduct != null) {
      return Response.json({
        "message": "Produk sudah ada",
      }, 409);
    }

    await Product().query().insert(dataProduct);

    return Response.json(
      {
        "message": "Success",
        "data": dataProduct,
      },
      200,
    );
  }

  Future<Response> show() async {
    final dataProduct = await Product().query().get();
    return Response.json({
      'message': 'Success',
      'data': dataProduct,
    }, 200);
  }

  Future<Response> update(Request req, int id) async {
  // Validasi input
  req.validate({
    'name': 'required|String',
    'description': 'required',
    'price': 'required',
  }, {
    'name.required': 'Nama tidak boleh kosong',
    'name.string': 'Nama tidak boleh angka',
    'description.required': 'Deskripsi tidak boleh kosong',
    'price.required': 'Harga tidak boleh kosong',
  });

  // Mengambil input data produk
  final dataProduct = req.input();
  // dataProduct['updated_at'] = DateTime.now().toIso8601String(); // Menambahkan updated_at

  // Memeriksa apakah produk dengan produk_id yang diberikan ada
  final existingProduct = await Product()
      .query()
      .where('produk_id', '=', id) // Pastikan menggunakan 'produk_id' di sini
      .first();

  if (existingProduct == null) {
    return Response.json({
      "message": "Produk tidak ditemukan",
    }, 404); // Produk tidak ditemukan
  }

  // Perbarui data produk menggunakan produk_id
  await Product()
      .query()
      .where('produk_id', '=', id) // Pastikan menggunakan 'produk_id' untuk update
      .update(dataProduct);

  return Response.json({
    "message": "Produk berhasil diperbarui",
    "data": dataProduct,
  }, 200); // Mengembalikan respons sukses
}


  Future<Response> destroy(int id) async {
    try {
      final product = await Product().query().where('id', '=', id).first();

      if (product == null) {
        return Response.json({
          'message': 'Produk dengan ID $id tidak ditemukan',
        }, 404);
      }

      await Product().query().where('id', '=', id).delete();
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

final ProductController productController = ProductController();
