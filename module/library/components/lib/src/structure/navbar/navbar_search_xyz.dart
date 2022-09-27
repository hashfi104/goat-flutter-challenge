import 'package:assets/assets.dart';
import 'package:components/components.dart';
import 'package:components/src/structure/search_bar_xyz.dart';
import 'package:flutter/material.dart';

import '../../button/button_link.dart';

class NavBarSearchXYZ extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback? onIconTap;
  final VoidCallback? onSearchBarTap;
  final List<MenuBarItem> menus;
  final Function(MenuBarItem)? onMenuTap;
  final bool showSeparatorLine;
  final bool searchEnabled;
  final BoxShadow? elevation;
  final String? action;
  final VoidCallback? onActionTap;
  final bool searchAutoFocus;
  final String? searchText;
  final String? searchPlaceholder;
  final ValueChanged<String>? onSearchTextChanged;
  final ValueChanged<String>? onSearchTextSubmitted;
  final String cancelSearchText;
  final VoidCallback? onSearchCancelled;
  final Key keyNavigationIcon;
  final Key keyAction;
  final String keyMoreMenu;
  final Key keySearchBar;
  final Key keySearchInput;
  final Key keySearchCancel;

  static const keyValueNavBarSearch = "navbar-search";
  static const keyValueSearchBar = "navbar-search-searchbar";
  static const keyValueSearchCancel = "navbar-search-cancel";
  static const keyValueMoreMenu = "navbar-search-more-menu";
  static const keyValueAction = "navbar-search-action";
  static const keyValueNavigationIcon = "navbar-search-navigation-icon";
  static const keyTappable = "navbar-search-tappable";

  /// * [onNavigationTap] Navigation icon on tap listener
  ///   Navigation icon always [BazaarIcon.backAndroid]
  ///   Set this to null to hide navigation icon
  /// * [menus] Navigation menu on the right side
  /// * [onMenuTap] Navigation menu item on tap listener
  /// * [onSearchBarTap] Search bar on tap listener, just in case you have to
  /// use this mv as an entry point only.
  /// * [showSeparatorLine] Whether show or hide separator line
  ///   on the bottom side
  /// * [searchEnabled] Whether search bar in enabled or disabled state
  /// * [elevation] Navigation bar search elevation
  ///   See [ShadowToken]
  /// * [action] Action text on the right side
  ///   Text instead of icon from navigation menu
  /// * [onActionTap] Action text on tap listener
  /// * [cancelSearchText] Cancel search button text
  ///   This one should not be empty
  /// * [searchAutoFocus] Auto focus search bar and show the keyboard
  /// * [searchPlaceholder] Search bar placeholder text
  /// * [onSearchTextChanged] Search bar text value changed listener
  /// * [onSearchTextSubmitted] Keyboard action tap listener
  /// * [onSearchCancelled] Search cancel button tap listener
  ///   [cancelSearchText] is the text value of cancel button
  /// * [searchAutoFocus] Auto focus the search bar and show the keyboard
  ///   Immediately show the keyboard when the screen opened
  /// * [keyNavigationIcon] Navigation icon key
  /// * [keyAction] Navigation [action] key
  /// * [keyMoreMenu] Navigation menu more icon key
  /// * [keySearchBar] Navigation search search bar key [searchText]
  /// * [keySearchCancel] Navigation search search bar cancel button
  /// * [navigationIconEventAttributes] Additional attributes
  ///   for [UserEvent.click] when navigation icon tapped
  /// * [moreMenuEventAttributes] Additional attributes for [UserEvent.click]
  ///   when more menu icon tapped
  /// * [searchEventAttributes] Additional attributes for [UserEvent.click]
  ///   when search bar tapped
  /// * [clearEventAttributes] Additional attributes for [UserEvent.click]
  ///   when search bar clear icon tapped
  /// * [cancelEventAttributes] Additional attributes for [UserEvent.click]
  ///   when cancel search button tapped
  /// * [focusEventAttributes] Additional attributes for [UserEvent.focusChange]
  ///   when search bar focus changed
  const NavBarSearchXYZ({
    Key? key = const Key(keyValueNavBarSearch),
    VoidCallback? onNavigationTap,
    this.menus = const [],
    this.onMenuTap,
    this.showSeparatorLine = true,
    this.searchEnabled = true,
    this.elevation,
    this.action,
    this.onSearchBarTap,
    this.onActionTap,
    this.searchText,
    this.searchPlaceholder,
    this.onSearchTextChanged,
    this.onSearchTextSubmitted,
    this.cancelSearchText = "",
    this.onSearchCancelled,
    this.searchAutoFocus = false,
    this.keyNavigationIcon = const Key(keyValueNavigationIcon),
    this.keyAction = const Key(keyValueAction),
    this.keyMoreMenu = keyValueMoreMenu,
    this.keySearchBar = const Key(keyValueSearchBar),
    this.keySearchInput = const Key(SearchBarXYZ.keyValueSearchInput),
    this.keySearchCancel = const Key(keyValueSearchCancel),
  })  : assert(
            cancelSearchText.length > 0, "Cancel search text should be filled"),
        onIconTap = onNavigationTap,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _NavBarSearchState();

  // navigation bar search height should include separator line height
  @override
  Size get preferredSize => const Size.fromHeight(56);
}

class _NavBarSearchState extends State<NavBarSearchXYZ> {
  final focusNode = FocusNode(debugLabel: "searchbar-focus");
  bool focused = false;
  String internalText = "";

  @override
  void initState() {
    super.initState();
    internalText = widget.searchText ?? "";

    // focused state should follow autoFocus value
    // this will prevent widget rebuild
    // and causing search to lose its focus
    focused = widget.searchAutoFocus;
  }

  @override
  Widget build(BuildContext context) {
    final navbar = NavBarXYZ.custom(
      title: _getNavigationTitle(),
      icon: _getNavigationIcon(),
      onIconTap: widget.onIconTap,
      showSeparatorLine: widget.showSeparatorLine,
      elevation: widget.elevation,
      onMenuTap: widget.onMenuTap,
      onActionTap: widget.onActionTap,
      // menu and action should be hidden when search bar is focused
      menus: focused ? const [] : widget.menus,
      action: focused ? null : widget.action,
      keyAction: widget.keyAction,
      keyNavigationIcon: widget.keyNavigationIcon,
      keyMoreMenu: widget.keyMoreMenu,
    );
    return navbar;
  }

  ImageHolder? _getNavigationIcon() {
    return !focused && widget.onIconTap != null
        ? ImageHolder.asset(XYZIcons.backAndroid)
        : null;
  }

  Widget _getNavigationTitle() {
    final searchEnabled =
        widget.onSearchBarTap != null ? false : widget.searchEnabled;

    final searchBar = SearchBarXYZ(
      enabled: searchEnabled,
      focusNode: focusNode,
      key: widget.keySearchBar,
      keySearchInput: widget.keySearchInput,
      text: internalText,
      placeholder: widget.searchPlaceholder,
      autoFocus: widget.searchAutoFocus,
      onTextChanged: (value) {
        // need to save the current text value
        // so that when doing a rebuild inside the widget itself
        // the current text value will not reset
        internalText = value;
        widget.onSearchTextChanged?.call(value);
      },
      onTextSubmitted: (value) {
        // clear focus of search bar
        FocusScope.of(context).unfocus();

        widget.onSearchTextSubmitted?.call(value);
      },
      onFocusChanged: (hasFocus) {
        focused = hasFocus;
        setState(() {});
      },
    );

    final searchContent = widget.onSearchBarTap != null
        ? Tappable.gestureDetector(
            key: const Key(NavBarSearchXYZ.keyTappable),
            child: searchBar,
            onTap: widget.onSearchBarTap,
          )
        : searchBar;

    return Row(children: [
      Expanded(child: searchContent),
      if (focused) ...[
        const SizedBox(width: 8),
        ButtonLink(
          widget.cancelSearchText,
          key: widget.keySearchCancel,
          onTap: () {
            final focus = FocusScope.of(context).focusedChild;
            if (focus?.debugLabel == focusNode.debugLabel) {
              // current search bar is focused
              // clear focus of search bar
              FocusScope.of(context).unfocus();
            } else {
              // search bar is not focused
              // manually set focused to false
              focused = false;
              setState(() {});
            }

            widget.onSearchCancelled?.call();
          },
        )
      ]
    ]);
  }
}
