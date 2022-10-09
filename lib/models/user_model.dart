class UserModel{
  String? name;
  String? uId;
  String? phone;
  String? email;

  UserModel(this.email,this.name,this.phone,this.uId);

  UserModel.fromJson(json){
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    uId = json['uId'];
  }
}