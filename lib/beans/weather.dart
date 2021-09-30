import 'dart:core';
import 'dart:convert';

class weather{
  String city;
  String cityid;
  String temp;
  String WD;
  String WS;
  String SD;
  String AP;
  String njd;
  String wSE;
  String time;
  String sm;
  String isRadar;
  String radar;

  weather( this.city,
    this.cityid,
    this.temp,
    this.WD,
    this.WS,
    this.SD,
    this.AP,
    this.njd,
    this.wSE,
    this.time,
    this.sm,
    this.isRadar,
    this.radar);

   static weather fromJson(Map<String, dynamic> json) {
    String city = json['city'];
    String cityid = json['cityid'];
    String temp = json['temp'];
    String wD = json['WD'];
    String wS = json['WS'];
    String sD = json['SD'];
    String aP = json['AP'];
    String njd = json['njd'];
    String wSE = json['WSE'];
    String time = json['time'];
    String sm = json['sm'];
    String isRadar = json['isRadar'];
    String radar = json['Radar'];
    return new weather(city, cityid, temp, wD, wS, sD, aP, njd, wSE, time, sm, isRadar, radar);
  }


}