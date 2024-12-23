// import 'package:new_vania/app/http/controllers/product_controller.dart';
// import 'package:new_vania/app/http/controllers/user_controller.dart';
import 'package:new_vania/app/http/controllers/auth_controller.dart';
import 'package:new_vania/app/http/controllers/user_controller.dart';
import 'package:new_vania/app/http/middleware/authenticate.dart';
import 'package:vania/vania.dart';

class ApiRoute implements Route {
  @override
  void register() {
    Router.basePrefix('api');
    Router.group(() {
      Router.post('register', authController.register);
      Router.post('login', authController.login);
    }, prefix: 'auth');

    Router.get('me', authController.me).middleware([AuthenticateMiddleware()]);

    Router.group(() {
      Router.patch('update-password', authController.register);
      Router.get('', userController.create);
    },prefix: 'user', middleware: [AuthenticateMiddleware()]);
  }
}
