// all border radius for app

import 'package:flutter/material.dart';

const double appBorderRadius = 25.0;

const BorderRadius appBorderRadiusAll =
    BorderRadius.all(Radius.circular(appBorderRadius));

const BorderRadius appBorderRadiusTopLeft =
    BorderRadius.only(topLeft: Radius.circular(appBorderRadius));

const BorderRadius appBorderRadiusTopRight =
    BorderRadius.only(topRight: Radius.circular(appBorderRadius));

const BorderRadius appBorderRadiusBottomLeft =
    BorderRadius.only(bottomLeft: Radius.circular(appBorderRadius));

const BorderRadius appBorderRadiusBottomRight =
    BorderRadius.only(bottomRight: Radius.circular(appBorderRadius));

const BorderRadius appBorderRadiusTop = BorderRadius.only(
    topLeft: Radius.circular(appBorderRadius),
    topRight: Radius.circular(appBorderRadius));

const BorderRadius appBorderRadiusBottom = BorderRadius.only(
    bottomLeft: Radius.circular(appBorderRadius),
    bottomRight: Radius.circular(appBorderRadius));
