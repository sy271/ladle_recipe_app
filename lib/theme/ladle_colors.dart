import 'package:flutter/material.dart';

/// Design tokens from `t(dark)` in docs/figma-export/App.tsx.
/// Access via `Theme.of(context).extension<LadleColors>()!` — never hardcode
/// a color in a widget.
class LadleColors extends ThemeExtension<LadleColors> {
  const LadleColors({
    required this.bg,
    required this.card,
    required this.cardBorder,
    required this.primary,
    required this.primaryFg,
    required this.heading,
    required this.body,
    required this.meta,
    required this.muted,
    required this.inputBg,
    required this.inputBorder,
    required this.border,
    required this.chipBg,
    required this.chipBorder,
    required this.chipActive,
    required this.chipActiveFg,
    required this.chipFg,
    required this.navBg,
    required this.navActive,
    required this.navInactive,
    required this.bannerBg,
    required this.bannerAccent,
    required this.pill,
    required this.pillBorder,
    required this.pillFg,
    required this.guidedBg,
    required this.guidedFg,
    required this.timerBg,
    required this.timerFg,
    required this.reviewBg,
    required this.divider,
    required this.frameBorder,
    required this.frameExtra,
    required this.statusFg,
    required this.notch,
    required this.avatar,
    required this.avatarFg,
    required this.heartFill,
    required this.starFg,
    required this.seeAll,
    required this.logoRingBorder,
    required this.logoRingBg,
    required this.logoIcon,
    required this.brandFg,
    required this.taglineFg,
    required this.labelFg,
    required this.successBg,
    required this.successFg,
    required this.inputFg,
    required this.placeholderFg,
    required this.tagBg,
    required this.tagBorder,
    required this.tagFg,
    required this.statsBg,
    required this.statsBorder,
  });

  final Color bg;
  final Color card;
  final Color cardBorder;
  final Color primary;
  final Color primaryFg;
  final Color heading;
  final Color body;
  final Color meta;
  final Color muted;
  final Color inputBg;
  final Color inputBorder;
  final Color border;
  final Color chipBg;
  final Color chipBorder;
  final Color chipActive;
  final Color chipActiveFg;
  final Color chipFg;
  final Color navBg;
  final Color navActive;
  final Color navInactive;
  final Color bannerBg;
  final Color bannerAccent;
  final Color pill;
  final Color pillBorder;
  final Color pillFg;
  final Color guidedBg;
  final Color guidedFg;
  final Color timerBg;
  final Color timerFg;
  final Color reviewBg;
  final Color divider;
  final Color frameBorder;
  final Color frameExtra;
  final Color statusFg;
  final Color notch;
  final Color avatar;
  final Color avatarFg;
  final Color heartFill;
  final Color starFg;
  final Color seeAll;
  final Color logoRingBorder;
  final Color logoRingBg;
  final Color logoIcon;
  final Color brandFg;
  final Color taglineFg;
  final Color labelFg;
  final Color successBg;
  final Color successFg;
  final Color inputFg;
  final Color placeholderFg;
  final Color tagBg;
  final Color tagBorder;
  final Color tagFg;
  final Color statsBg;
  final Color statsBorder;

  /// "Terracotta Night" — dark branch of `t(dark)`.
  static const dark = LadleColors(
    bg: Color(0xFF241E1A),
    card: Color(0xFF33291F),
    cardBorder: Color.fromRGBO(198, 123, 76, 0.18),
    primary: Color(0xFFC67B4C),
    primaryFg: Color(0xFF241E1A),
    heading: Color(0xFFF5EFE4),
    body: Color(0xFFF5EFE4),
    meta: Color(0xFFC67B4C),
    muted: Color(0xFF6B5B4A),
    inputBg: Color(0xFF2E2419),
    inputBorder: Color.fromRGBO(198, 123, 76, 0.22),
    border: Color.fromRGBO(198, 123, 76, 0.18),
    chipBg: Color(0xFF33291F),
    chipBorder: Color.fromRGBO(198, 123, 76, 0.22),
    chipActive: Color(0xFFC67B4C),
    chipActiveFg: Color(0xFF241E1A),
    chipFg: Color(0xFFC67B4C),
    navBg: Color(0xFF1E1610),
    navActive: Color(0xFFC67B4C),
    navInactive: Color(0xFF6B5B4A),
    bannerBg: Color(0xFF1A1410),
    bannerAccent: Color(0xFFC67B4C),
    pill: Color(0xFF2E2419),
    pillBorder: Color.fromRGBO(198, 123, 76, 0.3),
    pillFg: Color(0xFFC67B4C),
    guidedBg: Color(0xFFC67B4C),
    guidedFg: Color(0xFF241E1A),
    timerBg: Color.fromRGBO(36, 30, 26, 0.3),
    timerFg: Color(0xFF241E1A),
    reviewBg: Color(0xFF33291F),
    divider: Color.fromRGBO(198, 123, 76, 0.14),
    frameBorder: Color.fromRGBO(198, 123, 76, 0.22),
    frameExtra: Color.fromRGBO(0, 0, 0, 0.6),
    statusFg: Color(0xFFF5EFE4),
    notch: Color(0xFF1A1410),
    avatar: Color(0xFFC67B4C),
    avatarFg: Color(0xFF241E1A),
    heartFill: Color(0xFFC67B4C),
    starFg: Color(0xFFC67B4C),
    seeAll: Color(0xFFC67B4C),
    logoRingBorder: Color.fromRGBO(198, 123, 76, 0.35),
    logoRingBg: Color(0xFF2E2419),
    logoIcon: Color(0xFFC67B4C),
    brandFg: Color(0xFFF5EFE4),
    taglineFg: Color(0xFFC67B4C),
    labelFg: Color(0xFFC67B4C),
    successBg: Color.fromRGBO(198, 123, 76, 0.15),
    successFg: Color(0xFFC67B4C),
    inputFg: Color(0xFFF5EFE4),
    placeholderFg: Color(0xFF6B5B4A),
    tagBg: Color(0xFF2E2419),
    tagBorder: Color.fromRGBO(198, 123, 76, 0.2),
    tagFg: Color(0xFFC67B4C),
    statsBg: Color(0xFF2E2419),
    statsBorder: Color.fromRGBO(198, 123, 76, 0.18),
  );

  /// "Deep Plum & Blush" — light branch of `t(dark)`.
  static const light = LadleColors(
    bg: Color(0xFFF7ECE9),
    card: Color(0xFFFDFAF9),
    cardBorder: Color.fromRGBO(92, 58, 77, 0.1),
    primary: Color(0xFF5C3A4D),
    primaryFg: Color(0xFFFDFAF9),
    heading: Color(0xFF4B1528),
    body: Color(0xFF4B1528),
    meta: Color(0xFF993556),
    muted: Color(0xFFC4A0A9),
    inputBg: Color(0xFFF0DDD9),
    inputBorder: Color.fromRGBO(92, 58, 77, 0.15),
    border: Color.fromRGBO(92, 58, 77, 0.12),
    chipBg: Color(0xFFFFFFFF),
    chipBorder: Color.fromRGBO(92, 58, 77, 0.15),
    chipActive: Color(0xFF5C3A4D),
    chipActiveFg: Color(0xFFFDFAF9),
    chipFg: Color(0xFF993556),
    navBg: Color(0xFFFDFAF9),
    navActive: Color(0xFF5C3A4D),
    navInactive: Color(0xFFC4A0A9),
    bannerBg: Color(0xFF2D1F2D),
    bannerAccent: Color(0xFFC88B94),
    pill: Color(0xFFFFFFFF),
    pillBorder: Color.fromRGBO(92, 58, 77, 0.15),
    pillFg: Color(0xFF993556),
    guidedBg: Color(0xFFC88B94),
    guidedFg: Color(0xFF4B1528),
    timerBg: Color.fromRGBO(75, 21, 40, 0.18),
    timerFg: Color(0xFF4B1528),
    reviewBg: Color(0xFFFFFFFF),
    divider: Color.fromRGBO(92, 58, 77, 0.1),
    frameBorder: Color.fromRGBO(92, 58, 77, 0.12),
    frameExtra: Color.fromRGBO(92, 58, 77, 0.2),
    statusFg: Color(0xFF4B1528),
    notch: Color(0xFFEDD8D3),
    avatar: Color(0xFF5C3A4D),
    avatarFg: Color(0xFFFDFAF9),
    heartFill: Color(0xFF993556),
    starFg: Color(0xFF993556),
    seeAll: Color(0xFF993556),
    logoRingBorder: Color.fromRGBO(92, 58, 77, 0.2),
    logoRingBg: Color(0xFFFFFFFF),
    logoIcon: Color(0xFF5C3A4D),
    brandFg: Color(0xFF4B1528),
    taglineFg: Color(0xFF993556),
    labelFg: Color(0xFF993556),
    successBg: Color.fromRGBO(92, 58, 77, 0.08),
    successFg: Color(0xFF5C3A4D),
    inputFg: Color(0xFF4B1528),
    placeholderFg: Color(0xFFC4A0A9),
    tagBg: Color(0xFFFFFFFF),
    tagBorder: Color.fromRGBO(92, 58, 77, 0.15),
    tagFg: Color(0xFF993556),
    statsBg: Color(0xFFFFFFFF),
    statsBorder: Color.fromRGBO(92, 58, 77, 0.1),
  );

  @override
  LadleColors copyWith({
    Color? bg,
    Color? card,
    Color? cardBorder,
    Color? primary,
    Color? primaryFg,
    Color? heading,
    Color? body,
    Color? meta,
    Color? muted,
    Color? inputBg,
    Color? inputBorder,
    Color? border,
    Color? chipBg,
    Color? chipBorder,
    Color? chipActive,
    Color? chipActiveFg,
    Color? chipFg,
    Color? navBg,
    Color? navActive,
    Color? navInactive,
    Color? bannerBg,
    Color? bannerAccent,
    Color? pill,
    Color? pillBorder,
    Color? pillFg,
    Color? guidedBg,
    Color? guidedFg,
    Color? timerBg,
    Color? timerFg,
    Color? reviewBg,
    Color? divider,
    Color? frameBorder,
    Color? frameExtra,
    Color? statusFg,
    Color? notch,
    Color? avatar,
    Color? avatarFg,
    Color? heartFill,
    Color? starFg,
    Color? seeAll,
    Color? logoRingBorder,
    Color? logoRingBg,
    Color? logoIcon,
    Color? brandFg,
    Color? taglineFg,
    Color? labelFg,
    Color? successBg,
    Color? successFg,
    Color? inputFg,
    Color? placeholderFg,
    Color? tagBg,
    Color? tagBorder,
    Color? tagFg,
    Color? statsBg,
    Color? statsBorder,
  }) {
    return LadleColors(
      bg: bg ?? this.bg,
      card: card ?? this.card,
      cardBorder: cardBorder ?? this.cardBorder,
      primary: primary ?? this.primary,
      primaryFg: primaryFg ?? this.primaryFg,
      heading: heading ?? this.heading,
      body: body ?? this.body,
      meta: meta ?? this.meta,
      muted: muted ?? this.muted,
      inputBg: inputBg ?? this.inputBg,
      inputBorder: inputBorder ?? this.inputBorder,
      border: border ?? this.border,
      chipBg: chipBg ?? this.chipBg,
      chipBorder: chipBorder ?? this.chipBorder,
      chipActive: chipActive ?? this.chipActive,
      chipActiveFg: chipActiveFg ?? this.chipActiveFg,
      chipFg: chipFg ?? this.chipFg,
      navBg: navBg ?? this.navBg,
      navActive: navActive ?? this.navActive,
      navInactive: navInactive ?? this.navInactive,
      bannerBg: bannerBg ?? this.bannerBg,
      bannerAccent: bannerAccent ?? this.bannerAccent,
      pill: pill ?? this.pill,
      pillBorder: pillBorder ?? this.pillBorder,
      pillFg: pillFg ?? this.pillFg,
      guidedBg: guidedBg ?? this.guidedBg,
      guidedFg: guidedFg ?? this.guidedFg,
      timerBg: timerBg ?? this.timerBg,
      timerFg: timerFg ?? this.timerFg,
      reviewBg: reviewBg ?? this.reviewBg,
      divider: divider ?? this.divider,
      frameBorder: frameBorder ?? this.frameBorder,
      frameExtra: frameExtra ?? this.frameExtra,
      statusFg: statusFg ?? this.statusFg,
      notch: notch ?? this.notch,
      avatar: avatar ?? this.avatar,
      avatarFg: avatarFg ?? this.avatarFg,
      heartFill: heartFill ?? this.heartFill,
      starFg: starFg ?? this.starFg,
      seeAll: seeAll ?? this.seeAll,
      logoRingBorder: logoRingBorder ?? this.logoRingBorder,
      logoRingBg: logoRingBg ?? this.logoRingBg,
      logoIcon: logoIcon ?? this.logoIcon,
      brandFg: brandFg ?? this.brandFg,
      taglineFg: taglineFg ?? this.taglineFg,
      labelFg: labelFg ?? this.labelFg,
      successBg: successBg ?? this.successBg,
      successFg: successFg ?? this.successFg,
      inputFg: inputFg ?? this.inputFg,
      placeholderFg: placeholderFg ?? this.placeholderFg,
      tagBg: tagBg ?? this.tagBg,
      tagBorder: tagBorder ?? this.tagBorder,
      tagFg: tagFg ?? this.tagFg,
      statsBg: statsBg ?? this.statsBg,
      statsBorder: statsBorder ?? this.statsBorder,
    );
  }

  @override
  LadleColors lerp(ThemeExtension<LadleColors>? other, double t) {
    if (other is! LadleColors) return this;
    return LadleColors(
      bg: Color.lerp(bg, other.bg, t)!,
      card: Color.lerp(card, other.card, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryFg: Color.lerp(primaryFg, other.primaryFg, t)!,
      heading: Color.lerp(heading, other.heading, t)!,
      body: Color.lerp(body, other.body, t)!,
      meta: Color.lerp(meta, other.meta, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      inputBg: Color.lerp(inputBg, other.inputBg, t)!,
      inputBorder: Color.lerp(inputBorder, other.inputBorder, t)!,
      border: Color.lerp(border, other.border, t)!,
      chipBg: Color.lerp(chipBg, other.chipBg, t)!,
      chipBorder: Color.lerp(chipBorder, other.chipBorder, t)!,
      chipActive: Color.lerp(chipActive, other.chipActive, t)!,
      chipActiveFg: Color.lerp(chipActiveFg, other.chipActiveFg, t)!,
      chipFg: Color.lerp(chipFg, other.chipFg, t)!,
      navBg: Color.lerp(navBg, other.navBg, t)!,
      navActive: Color.lerp(navActive, other.navActive, t)!,
      navInactive: Color.lerp(navInactive, other.navInactive, t)!,
      bannerBg: Color.lerp(bannerBg, other.bannerBg, t)!,
      bannerAccent: Color.lerp(bannerAccent, other.bannerAccent, t)!,
      pill: Color.lerp(pill, other.pill, t)!,
      pillBorder: Color.lerp(pillBorder, other.pillBorder, t)!,
      pillFg: Color.lerp(pillFg, other.pillFg, t)!,
      guidedBg: Color.lerp(guidedBg, other.guidedBg, t)!,
      guidedFg: Color.lerp(guidedFg, other.guidedFg, t)!,
      timerBg: Color.lerp(timerBg, other.timerBg, t)!,
      timerFg: Color.lerp(timerFg, other.timerFg, t)!,
      reviewBg: Color.lerp(reviewBg, other.reviewBg, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      frameBorder: Color.lerp(frameBorder, other.frameBorder, t)!,
      frameExtra: Color.lerp(frameExtra, other.frameExtra, t)!,
      statusFg: Color.lerp(statusFg, other.statusFg, t)!,
      notch: Color.lerp(notch, other.notch, t)!,
      avatar: Color.lerp(avatar, other.avatar, t)!,
      avatarFg: Color.lerp(avatarFg, other.avatarFg, t)!,
      heartFill: Color.lerp(heartFill, other.heartFill, t)!,
      starFg: Color.lerp(starFg, other.starFg, t)!,
      seeAll: Color.lerp(seeAll, other.seeAll, t)!,
      logoRingBorder: Color.lerp(logoRingBorder, other.logoRingBorder, t)!,
      logoRingBg: Color.lerp(logoRingBg, other.logoRingBg, t)!,
      logoIcon: Color.lerp(logoIcon, other.logoIcon, t)!,
      brandFg: Color.lerp(brandFg, other.brandFg, t)!,
      taglineFg: Color.lerp(taglineFg, other.taglineFg, t)!,
      labelFg: Color.lerp(labelFg, other.labelFg, t)!,
      successBg: Color.lerp(successBg, other.successBg, t)!,
      successFg: Color.lerp(successFg, other.successFg, t)!,
      inputFg: Color.lerp(inputFg, other.inputFg, t)!,
      placeholderFg: Color.lerp(placeholderFg, other.placeholderFg, t)!,
      tagBg: Color.lerp(tagBg, other.tagBg, t)!,
      tagBorder: Color.lerp(tagBorder, other.tagBorder, t)!,
      tagFg: Color.lerp(tagFg, other.tagFg, t)!,
      statsBg: Color.lerp(statsBg, other.statsBg, t)!,
      statsBorder: Color.lerp(statsBorder, other.statsBorder, t)!,
    );
  }
}
