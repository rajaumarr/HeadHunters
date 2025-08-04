import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:head_hunter/utils/extensions/media-query.dart';

import '../constants/colors.dart';
import '../constants/fonts.dart';

class CustomTextFiled extends StatelessWidget {
 final String? hintText;
 final TextEditingController? controller;
 final bool? isFilled;
 final Color? fillColor;
 final String? fontFamily;
 final Color? hintColor;
 final  FontWeight? fontWeight;
 final double? hintTextSize;
 final  String? Function(String?)? validator;
 final String? Function(String?)? onChange;
 final String? Function(String?)? onSubmit;
 final String? Function()? passwordFunction;
 final  double? borderRadius;
 final bool? isBorder;
 final bool? isFocusBorder;
 final  IconData? suffixIcon;
 final IconData? prefixIcon;
 final  bool? isErrorBorder;
 final TextInputType? keyboardType;
 final bool? isPassword;
 final  IconData? beforePasswordIcon;
 final IconData? afterPasswordIcon;
 final bool? isObscure;
 final bool? isShowPrefixIcon;
 final bool? isShowPrefixImage;
 final String? prefixImgUrl;
 final TextAlign? textAlign;
 final int? maxLine;
 final List<TextInputFormatter>? inputFormatters; // New parame
  const CustomTextFiled(
      {super.key,
        this.hintText,
        this.controller,
        this.isFilled,
        this.fillColor,
        this.fontFamily,
        this.hintColor,
        this.hintTextSize,
        this.fontWeight,
        this.validator,
        this.isBorder,
        this.borderRadius,
        this.suffixIcon,
        this.prefixIcon,
        this.isErrorBorder,
        this.onChange,
        this.keyboardType,
        this.isPassword,
        this.passwordFunction,
        this.beforePasswordIcon,
        this.isObscure,
        this.afterPasswordIcon,
        this.isShowPrefixIcon,
        this.isFocusBorder,
        this.isShowPrefixImage=false,
        this.prefixImgUrl,
        this.textAlign,
        this.inputFormatters,
        this.maxLine,
        this.onSubmit
      });

  @override
  Widget build(BuildContext context) {
    final screenHeight = context.screenHeight;
    return TextFormField(
      textAlign: textAlign ?? TextAlign.start,
      style: TextStyle(
        fontFamily: fontFamily ?? AppFonts.monserrat,
        fontSize: hintTextSize ?? 16.sp,
        color: hintColor ?? Colors.black.withOpacity(0.5),
        fontWeight: fontWeight ?? FontWeight.w400,
      ),
      controller: controller,
      validator: validator,
      onChanged: onChange,
      onFieldSubmitted: onSubmit,
      keyboardType: keyboardType,
      obscureText: isObscure ?? false,
      maxLines: maxLine ?? 1,

      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        suffixIcon: isPassword == true
            ? IconButton(
                onPressed: passwordFunction,
                icon: Icon(
                    isObscure == true ? beforePasswordIcon : afterPasswordIcon))
            : null,
        prefixIcon: isShowPrefixIcon == false
            ? null
            : isShowPrefixImage == true
                ? Image.asset(
                    prefixImgUrl!,
                    scale: 1.7.sp,
                  )
                : Icon(
                    prefixIcon,
                    color: blackColor,
                  ),
        filled: isFilled ?? true,
        fillColor: fillColor ?? whiteColor,
        //contentPadding: const EdgeInsets.only(left: 12),
        hintText: hintText,
        hintStyle: TextStyle(
          fontFamily: fontFamily ?? AppFonts.monserrat,
          fontSize: hintTextSize ?? 16.sp,
          color: hintColor ?? Colors.black.withOpacity(0.5),
          fontWeight: fontWeight ?? FontWeight.w400,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius!),
          borderSide: const BorderSide(color: Color(0xffE2E2E2)),
        ),
        border: isBorder == true
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius!),
                borderSide: const BorderSide(color: Colors.grey))
            : InputBorder.none,
        errorBorder: isErrorBorder == true
            ? OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(borderRadius!))
            : InputBorder.none,
      ),
    );
  }
}
