import 'package:flutter/material.dart';

class FileExtensionIcon {
  static const String _csv = "assets/images/icons/extensions/csv.png";
  static const String _doc = "assets/images/icons/extensions/doc.png";
  static const String _docx = "assets/images/icons/extensions/docx.png";
  static const String _gif = "assets/images/icons/extensions/gif.png";
  static const String _jpg = "assets/images/icons/extensions/jpg.png";
  static const String _mp3 = "assets/images/icons/extensions/mp3.png";
  static const String _mp4 = "assets/images/icons/extensions/mp4.png";
  static const String _other = "assets/images/icons/extensions/outro.png";
  static const String _png = "assets/images/icons/extensions/png.png";
  static const String _ppt = "assets/images/icons/extensions/ppt.png";
  static const String _pptx = "assets/images/icons/extensions/pptx.png";
  static const String _psd = "assets/images/icons/extensions/psd.png";
  static const String _rar = "assets/images/icons/extensions/rar.png";
  static const String _svg = "assets/images/icons/extensions/svg.png";
  static const String _tiff = "assets/images/icons/extensions/tiff.png";
  static const String _txt = "assets/images/icons/extensions/txt.png";
  static const String _xls = "assets/images/icons/extensions/xls.png";
  static const String _xlsx = "assets/images/icons/extensions/xlsx.png";
  static const String _zip = "assets/images/icons/extensions/zip.png";

  static Widget getByExtension(String? ext, {double? width}) {
    ext = ext ?? "other";
    switch (ext.toUpperCase()) {
      case "CSV":
        return _fromAssert(_csv, width: width);
      case "DOC":
        return _fromAssert(_doc, width: width);
      case "DOCX":
        return _fromAssert(_docx, width: width);
      case "GIF":
        return _fromAssert(_gif, width: width);
      case "JPG":
        return _fromAssert(_jpg, width: width);
      case "MP3":
        return _fromAssert(_mp3, width: width);
      case "MP4":
        return _fromAssert(_mp4, width: width);
      case "PNG":
        return _fromAssert(_png, width: width);
      case "PPT":
        return _fromAssert(_ppt, width: width);
      case "PPTX":
        return _fromAssert(_pptx, width: width);
      case "PSD":
        return _fromAssert(_psd, width: width);
      case "RAR":
        return _fromAssert(_rar, width: width);
      case "SVG":
        return _fromAssert(_svg, width: width);
      case "TIFF":
        return _fromAssert(_tiff, width: width);
      case "TXT":
        return _fromAssert(_txt, width: width);
      case "XLS":
        return _fromAssert(_xls, width: width);
      case "XLSX":
        return _fromAssert(_xlsx, width: width);
      case "ZIP":
        return _fromAssert(_zip, width: width);
      default:
        return _fromAssert(_other, width: width);
    }
  }

  static Widget _fromAssert(String path, {double? width = 40}) {
    return Image.asset(
      path,
      width: width,
    );
  }
}
