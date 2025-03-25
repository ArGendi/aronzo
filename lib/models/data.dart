
class Data<T>{
  T data;
  Status status;

  Data(this.data, this.status);
}

enum Status{
  success,
  fail,
}