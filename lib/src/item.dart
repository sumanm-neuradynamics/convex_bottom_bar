/*
 *  Copyright 2020 Chaobin Wu <chaobinwu89@gmail.com>
 *  
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *  
 *      http://www.apache.org/licenses/LICENSE-2.0
 *  
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Function type for building title widget based on active state
typedef TitleBuilder = Widget Function(bool isActive);

/// Tab item used for [ConvexAppBar].
class TabItem<T> {
  /// this code is added by moein
  final String? fontFamily;

  /// Tab text. Can be a String, a Widget, or a function that takes isActive and returns a Widget.
  final dynamic title;

  /// IconData or Image.
  ///
  /// ![](https://github.com/hacktons/convex_bottom_bar/raw/master/doc/appbar-image.gif)
  final T icon;

  /// Optional if not provided ,[icon] is used.
  final T? activeIcon;

  /// Whether icon should blend with color.
  /// If [icon] is instance of [IconData] then blend is default to true, otherwise false
  final bool blend;

  /// Create item
  const TabItem({
    this.fontFamily,
    this.title = '',
    required this.icon,
    this.activeIcon,
    bool? isIconBlend,
  })  : assert(icon is IconData || icon is Widget,
            'TabItem only support IconData and Widget'),
        assert(
            title == null ||
                title is String ||
                title is Widget ||
                title is Function,
            'TabItem title must be String, Widget, or TitleBuilder function (Widget Function(bool))'),
        blend = isIconBlend ?? (icon is IconData);

  /// Build title widget from title (String, Widget, or TitleBuilder function)
  /// If title is a String, it will be wrapped in a Text widget with the given style
  /// If title is a Widget, it will be returned as is
  /// If title is a TitleBuilder function, it will be called with isActive parameter
  /// If title is null or empty String, returns null
  Widget? buildTitleWidget(TextStyle? textStyle, bool isActive) {
    if (title == null) return null;
    // Check if it's a function (TitleBuilder)
    if (title is Function) {
      try {
        final result = title(isActive);
        if (result is Widget) {
          return result;
        }
      } catch (e) {
        // If function call fails, it's not a valid TitleBuilder
      }
    }
    if (title is Widget) return title as Widget;
    if (title is String) {
      final String titleStr = title as String;
      if (titleStr.isEmpty) return null;
      return Text(titleStr, style: textStyle);
    }
    return null;
  }

  /// Check if title is empty or null
  bool get hasTitle {
    if (title == null) return false;
    if (title is Widget) return true;
    if (title is Function) return true; // TitleBuilder is a Function
    if (title is String) {
      return (title as String).isNotEmpty;
    }
    return false;
  }
}
