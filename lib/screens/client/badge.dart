import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

appointmentstatus(String status) {
  if (status == 'NEW') {
    return Badge(
      toAnimate: false,
      shape: BadgeShape.square,
      badgeColor: const Color.fromARGB(255, 117, 192, 238),
      borderRadius: BorderRadius.circular(8),
      badgeContent: Text(status, style: const TextStyle(color: Colors.white)),
    );
  } else if (status == 'OPEN') {
    return Badge(
      toAnimate: false,
      shape: BadgeShape.square,
      badgeColor: const Color.fromARGB(255, 34, 74, 235),
      borderRadius: BorderRadius.circular(8),
      badgeContent: Text(status, style: const TextStyle(color: Colors.white)),
    );
  } else if (status == 'REJECTED') {
    return Badge(
      toAnimate: false,
      shape: BadgeShape.square,
      badgeColor: const Color.fromARGB(255, 214, 34, 34),
      borderRadius: BorderRadius.circular(8),
      badgeContent: Text(status, style: const TextStyle(color: Colors.white)),
    );
  } else if (status == 'CANCELLED') {
    return Badge(
      toAnimate: false,
      shape: BadgeShape.square,
      badgeColor: Colors.green,
      borderRadius: BorderRadius.circular(8),
      badgeContent: Text(status, style: const TextStyle(color: Colors.white)),
    );
  } else if (status == 'NO SHOW') {
    return Badge(
      toAnimate: false,
      shape: BadgeShape.square,
      badgeColor: const Color.fromARGB(255, 245, 178, 7),
      borderRadius: BorderRadius.circular(8),
      badgeContent: Text(status, style: const TextStyle(color: Colors.white)),
    );
  } else if (status == 'WAITING') {
    return Badge(
      toAnimate: false,
      shape: BadgeShape.square,
      badgeColor: const Color.fromARGB(255, 235, 218, 90),
      borderRadius: BorderRadius.circular(8),
      badgeContent: Text(status, style: const TextStyle(color: Colors.white)),
    );
  } else if (status == 'WAITING FOR CLIENT') {
    return Badge(
      toAnimate: false,
      shape: BadgeShape.square,
      badgeColor: const Color.fromARGB(255, 249, 201, 26),
      borderRadius: BorderRadius.circular(8),
      badgeContent: Text(status, style: const TextStyle(color: Colors.white)),
    );
  } else if (status == 'CANCELLED BY CLINICIAN') {
    return Badge(
      toAnimate: false,
      shape: BadgeShape.square,
      badgeColor: const Color.fromARGB(255, 214, 34, 34),
      borderRadius: BorderRadius.circular(8),
      badgeContent: Text(status, style: const TextStyle(color: Colors.white)),
    );
  } else if (status == 'CONFIRMED') {
    return Badge(
      toAnimate: false,
      shape: BadgeShape.square,
      badgeColor: Colors.green,
      borderRadius: BorderRadius.circular(8),
      badgeContent: Text(status, style: const TextStyle(color: Colors.white)),
    );
  } else if (status == 'COMPLETED') {
    return Badge(
      toAnimate: false,
      shape: BadgeShape.square,
      badgeColor: Color.fromARGB(255, 0, 0, 0),
      borderRadius: BorderRadius.circular(8),
      badgeContent: Text(status, style: const TextStyle(color: Colors.white)),
    );
  } else if (status == 'WAITING FOR PAYMENT') {
    return Badge(
      toAnimate: false,
      shape: BadgeShape.square,
      badgeColor: const Color.fromARGB(255, 238, 148, 3),
      borderRadius: BorderRadius.circular(8),
      badgeContent: Text(status, style: const TextStyle(color: Colors.white)),
    );
  } else if (status == 'WAITING FOR INSURANCE CNFRM') {
    return Badge(
      toAnimate: false,
      shape: BadgeShape.square,
      badgeColor: const Color.fromARGB(255, 238, 148, 3),
      borderRadius: BorderRadius.circular(8),
      badgeContent: Text(status, style: const TextStyle(color: Colors.white)),
    );
  }
}
