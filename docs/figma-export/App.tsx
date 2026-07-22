import { useState, useRef, useEffect } from "react";
import {
  Eye, EyeOff, CheckCircle2, UtensilsCrossed,
  Search, Heart, Bookmark, Home, User, Plus,
  Clock, Users, ChevronLeft, Play, Pause, Timer,
  ShoppingBasket, ChevronRight, Star, X, Settings,
  LogOut, ArrowRight, Mail, Lock, AlignLeft,
} from "lucide-react";

// ─── Types ────────────────────────────────────────────────────────────────────
type Screen = "signin" | "signup" | "forgot" | "home" | "search" | "detail" | "saved" | "profile";

type Recipe = {
  id: string; name: string; cat: string; time: string;
  rating: string; photo: string; heroPhoto: string;
  serves: string; by: string;
};

// ─── Data ─────────────────────────────────────────────────────────────────────
const PHOTOS = {
  ragu:      "https://images.unsplash.com/photo-1611270629569-8b357cb88da9?w=400&h=280&fit=crop&auto=format",
  raguHero:  "https://images.unsplash.com/photo-1600803907087-f56d462fd26b?w=800&h=500&fit=crop&auto=format",
  slaw:      "https://images.unsplash.com/photo-1573403707491-38a4ea19edc1?w=400&h=280&fit=crop&auto=format",
  pancakes:  "https://images.unsplash.com/photo-1612182062633-9ff3b3598e96?w=400&h=280&fit=crop&auto=format",
  miso:      "https://images.unsplash.com/photo-1763470260582-894ae15f43bb?w=400&h=280&fit=crop&auto=format",
  chocTart:  "https://images.unsplash.com/photo-1616031037011-087000171abe?w=400&h=280&fit=crop&auto=format",
  shakshuka: "https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=300&h=300&fit=crop&auto=format",
  tomSoup:   "https://images.unsplash.com/photo-1547592180-85f173990554?w=300&h=300&fit=crop&auto=format",
  chicken:   "https://images.unsplash.com/photo-1598103442097-8b74394b95c6?w=300&h=300&fit=crop&auto=format",
  bowl:      "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=300&h=300&fit=crop&auto=format",
  avocado:   "https://images.unsplash.com/photo-1525351484163-7529414344d8?w=300&h=300&fit=crop&auto=format",
};

const ALL_RECIPES: Recipe[] = [
  { id: "ragu",      name: "Weeknight Ragu",     cat: "Main",      time: "45 min", rating: "4.8", photo: PHOTOS.ragu,      heroPhoto: PHOTOS.raguHero,  serves: "4", by: "@theladle" },
  { id: "slaw",      name: "Citrus Slaw",         cat: "Side",      time: "15 min", rating: "4.5", photo: PHOTOS.slaw,      heroPhoto: PHOTOS.slaw,      serves: "4", by: "@freshbowl" },
  { id: "pancakes",  name: "Berry Pancakes",      cat: "Breakfast", time: "20 min", rating: "4.9", photo: PHOTOS.pancakes,  heroPhoto: PHOTOS.pancakes,  serves: "2", by: "@morningkitchen" },
  { id: "miso",      name: "Miso Soup",           cat: "Soup",      time: "10 min", rating: "4.6", photo: PHOTOS.miso,      heroPhoto: PHOTOS.miso,      serves: "2", by: "@notethanun" },
  { id: "tart",      name: "Choc Tart",           cat: "Dessert",   time: "60 min", rating: "4.7", photo: PHOTOS.chocTart,  heroPhoto: PHOTOS.chocTart,  serves: "8", by: "@sweettable" },
  { id: "shakshuka", name: "Golden Shakshuka",    cat: "Breakfast", time: "25 min", rating: "4.7", photo: PHOTOS.shakshuka, heroPhoto: PHOTOS.shakshuka, serves: "2", by: "@nourish" },
  { id: "tomsoup",   name: "Roasted Tomato Soup", cat: "Soup",      time: "35 min", rating: "4.6", photo: PHOTOS.tomSoup,   heroPhoto: PHOTOS.tomSoup,   serves: "4", by: "@warmkitchen" },
  { id: "chicken",   name: "Lemon Olive Chicken", cat: "Main",      time: "55 min", rating: "4.9", photo: PHOTOS.chicken,   heroPhoto: PHOTOS.chicken,   serves: "4", by: "@theladle" },
  { id: "bowl",      name: "Summer Grain Bowl",   cat: "Vegetarian","time": "20 min", rating: "4.8", photo: PHOTOS.bowl,      heroPhoto: PHOTOS.bowl,      serves: "2", by: "@greenbite" },
  { id: "avo",       name: "Avocado Toast",        cat: "Breakfast", time: "10 min", rating: "4.5", photo: PHOTOS.avocado,   heroPhoto: PHOTOS.avocado,   serves: "1", by: "@brunchclub" },
];

const PICKS = ALL_RECIPES.slice(0, 5);
const RECOMMENDED = ALL_RECIPES.slice(5, 8);
const CATEGORIES = ["Main course", "Side", "Beverage", "Breakfast", "Dessert", "Soup", "Salad", "Snack", "Vegetarian"];

const INGREDIENTS = [
  { name: "Beef mince",    amount: "500g" },
  { name: "Passata",       amount: "700ml" },
  { name: "Pancetta",      amount: "120g" },
  { name: "Soffritto mix", amount: "1 cup" },
  { name: "Red wine",      amount: "150ml" },
  { name: "Garlic cloves", amount: "4" },
  { name: "Bay leaves",    amount: "2" },
  { name: "Olive oil",     amount: "2 tbsp" },
  { name: "Salt & pepper", amount: "to taste" },
];

// ─── Theme ────────────────────────────────────────────────────────────────────
function t(dark: boolean) {
  return dark ? {
    bg: "#241E1A", card: "#33291F", cardBorder: "rgba(198,123,76,0.18)",
    primary: "#C67B4C", primaryFg: "#241E1A",
    heading: "#F5EFE4", body: "#F5EFE4", meta: "#C67B4C", muted: "#6B5B4A",
    inputBg: "#2E2419", inputBorder: "rgba(198,123,76,0.22)",
    border: "rgba(198,123,76,0.18)", chipBg: "#33291F", chipBorder: "rgba(198,123,76,0.22)",
    chipActive: "#C67B4C", chipActiveFg: "#241E1A", chipFg: "#C67B4C",
    navBg: "#1E1610", navActive: "#C67B4C", navInactive: "#6B5B4A",
    bannerBg: "#1A1410", bannerAccent: "#C67B4C",
    pill: "#2E2419", pillBorder: "rgba(198,123,76,0.3)", pillFg: "#C67B4C",
    guidedBg: "#C67B4C", guidedFg: "#241E1A",
    timerBg: "rgba(36,30,26,0.3)", timerFg: "#241E1A",
    reviewBg: "#33291F", divider: "rgba(198,123,76,0.14)",
    frameBorder: "border border-[rgba(198,123,76,0.22)]",
    frameExtra: "shadow-2xl shadow-black/60",
    statusFg: "#F5EFE4", notch: "#1A1410",
    avatar: "#C67B4C", avatarFg: "#241E1A",
    heartFill: "#C67B4C", starFg: "#C67B4C", seeAll: "#C67B4C",
    logoRing: "border-2 border-[rgba(198,123,76,0.35)] bg-[#2E2419]",
    logoIcon: "#C67B4C", brandFg: "#F5EFE4", taglineFg: "#C67B4C", labelFg: "#C67B4C",
    successBg: "rgba(198,123,76,0.15)", successFg: "#C67B4C",
    inputFg: "#F5EFE4", placeholderFg: "#6B5B4A",
    tagBg: "#2E2419", tagBorder: "rgba(198,123,76,0.2)", tagFg: "#C67B4C",
    statsBg: "#2E2419", statsBorder: "rgba(198,123,76,0.18)",
  } : {
    bg: "#F7ECE9", card: "#FDFAF9", cardBorder: "rgba(92,58,77,0.1)",
    primary: "#5C3A4D", primaryFg: "#FDFAF9",
    heading: "#4B1528", body: "#4B1528", meta: "#993556", muted: "#C4A0A9",
    inputBg: "#F0DDD9", inputBorder: "rgba(92,58,77,0.15)",
    border: "rgba(92,58,77,0.12)", chipBg: "white", chipBorder: "rgba(92,58,77,0.15)",
    chipActive: "#5C3A4D", chipActiveFg: "#FDFAF9", chipFg: "#993556",
    navBg: "#FDFAF9", navActive: "#5C3A4D", navInactive: "#C4A0A9",
    bannerBg: "#2D1F2D", bannerAccent: "#C88B94",
    pill: "white", pillBorder: "rgba(92,58,77,0.15)", pillFg: "#993556",
    guidedBg: "#C88B94", guidedFg: "#4B1528",
    timerBg: "rgba(75,21,40,0.18)", timerFg: "#4B1528",
    reviewBg: "white", divider: "rgba(92,58,77,0.1)",
    frameBorder: "border border-[rgba(92,58,77,0.12)]",
    frameExtra: "shadow-2xl shadow-[#5C3A4D]/20",
    statusFg: "#4B1528", notch: "#EDD8D3",
    avatar: "#5C3A4D", avatarFg: "#FDFAF9",
    heartFill: "#993556", starFg: "#993556", seeAll: "#993556",
    logoRing: "border-2 border-[rgba(92,58,77,0.2)] bg-white",
    logoIcon: "#5C3A4D", brandFg: "#4B1528", taglineFg: "#993556", labelFg: "#993556",
    successBg: "rgba(92,58,77,0.08)", successFg: "#5C3A4D",
    inputFg: "#4B1528", placeholderFg: "#C4A0A9",
    tagBg: "white", tagBorder: "rgba(92,58,77,0.15)", tagFg: "#993556",
    statsBg: "white", statsBorder: "rgba(92,58,77,0.1)",
  };
}

// ─── Shared UI ────────────────────────────────────────────────────────────────
function StatusBar({ dark }: { dark: boolean }) {
  const th = t(dark);
  return (
    <div className="flex justify-between items-center px-7 pt-4 pb-1 text-[11px] font-semibold flex-shrink-0" style={{ color: th.statusFg }}>
      <span>9:41</span>
      <div className="w-24 h-5 rounded-full" style={{ background: th.notch }} />
      <div className="flex gap-1 items-center">
        <svg width="14" height="10" viewBox="0 0 14 10" fill="currentColor" opacity="0.8">
          <rect x="0" y="3" width="3" height="7" rx="0.5"/><rect x="4" y="2" width="3" height="8" rx="0.5"/>
          <rect x="8" y="0.5" width="3" height="9.5" rx="0.5"/><rect x="12" y="0" width="2" height="10" rx="0.5" opacity="0.3"/>
        </svg>
        <svg width="20" height="10" viewBox="0 0 20 10" fill="currentColor">
          <rect x="0" y="0" width="18" height="10" rx="2" stroke="currentColor" strokeWidth="1.2" fill="none" opacity="0.5"/>
          <rect x="18.5" y="3" width="1.5" height="4" rx="0.75" opacity="0.5"/>
          <rect x="1" y="1" width="14" height="8" rx="1.2"/>
        </svg>
      </div>
    </div>
  );
}

function GoogleIcon() {
  return (
    <svg width="18" height="18" viewBox="0 0 24 24">
      <path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" fill="#4285F4"/>
      <path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853"/>
      <path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l3.66-2.84z" fill="#FBBC05"/>
      <path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335"/>
    </svg>
  );
}

function BottomNav({ dark, active, navigate }: { dark: boolean; active: string; navigate: (s: Screen) => void }) {
  const th = t(dark);
  return (
    <div className="flex-shrink-0 flex items-center justify-around px-2 pt-2 pb-5 border-t" style={{ background: th.navBg, borderColor: th.border }}>
      {[
        { id: "home",    icon: Home,     label: "Home" },
        { id: "search",  icon: Search,   label: "Search" },
        { id: "add",     icon: Plus,     label: "" },
        { id: "saved",   icon: Bookmark, label: "Saved" },
        { id: "profile", icon: User,     label: "Profile" },
      ].map(({ id, icon: Icon, label }) =>
        id === "add" ? (
          <button key={id} onClick={() => navigate("search")}
            className="w-12 h-12 rounded-full flex items-center justify-center -mt-5 shadow-lg transition-transform active:scale-95"
            style={{ background: th.primary, color: th.primaryFg, boxShadow: `0 4px 16px ${th.primary}66` }}>
            <Plus size={22} strokeWidth={2.5} />
          </button>
        ) : (
          <button key={id} onClick={() => navigate(id as Screen)} className="flex flex-col items-center gap-0.5 px-2 py-1">
            <Icon size={22} strokeWidth={active === id ? 2.2 : 1.6} style={{ color: active === id ? th.navActive : th.navInactive }} />
            {label && <span className="text-[9px] font-semibold" style={{ color: active === id ? th.navActive : th.navInactive }}>{label}</span>}
          </button>
        )
      )}
    </div>
  );
}

function RecipeCard({ recipe, dark, saved, onSave, onTap, size = "md" }: {
  recipe: Recipe; dark: boolean; saved: boolean;
  onSave: () => void; onTap: () => void; size?: "sm" | "md";
}) {
  const th = t(dark);
  const w = size === "sm" ? "w-[130px]" : "w-[148px]";
  const h = size === "sm" ? "h-[88px]" : "h-[100px]";
  return (
    <button onClick={onTap} className={`flex-shrink-0 ${w} rounded-[18px] overflow-hidden border text-left transition-transform active:scale-95`} style={{ background: th.card, borderColor: th.cardBorder }}>
      <div className={`relative ${h} bg-[#C4A0A9]`}>
        <img src={recipe.photo} alt={recipe.name} className="w-full h-full object-cover" />
        <button onClick={e => { e.stopPropagation(); onSave(); }}
          className="absolute top-2 right-2 w-7 h-7 rounded-full flex items-center justify-center transition-transform active:scale-90"
          style={{ background: "rgba(0,0,0,0.35)" }}>
          <Bookmark size={13} fill={saved ? th.navActive : "none"} style={{ color: saved ? th.navActive : "white" }} strokeWidth={2} />
        </button>
      </div>
      <div className="p-2.5">
        <p className="text-[13px] font-bold leading-tight mb-1 line-clamp-1" style={{ fontFamily: "'Playfair Display', serif", color: th.heading }}>{recipe.name}</p>
        <p className="text-[10px] font-medium" style={{ color: th.meta }}>{recipe.cat} · {recipe.time} · <span style={{ color: th.starFg }}>★</span>{recipe.rating}</p>
      </div>
    </button>
  );
}

// ─── Screen: Sign In ──────────────────────────────────────────────────────────
function SignInScreen({ dark, navigate }: { dark: boolean; navigate: (s: Screen) => void }) {
  const th = t(dark);
  const [showPw, setShowPw] = useState(false);
  const [email, setEmail] = useState("maya@example.com");

  return (
    <div className="flex-1 overflow-y-auto" style={{ scrollbarWidth: "none", background: th.bg }}>
      <div className="px-7 pt-6 pb-10 flex flex-col">
        <div className="flex flex-col items-center gap-3 mb-8">
          <div className={`w-16 h-16 rounded-2xl flex items-center justify-center ${th.logoRing}`}>
            <UtensilsCrossed size={30} color={th.logoIcon} strokeWidth={1.8} />
          </div>
          <div className="text-center">
            <h1 className="text-[32px] leading-none tracking-tight mb-1" style={{ fontFamily: "'Playfair Display', serif", fontWeight: 800, color: th.brandFg }}>Ladle</h1>
            <p className="text-[13px]" style={{ fontStyle: "italic", color: th.taglineFg }}>Big flavour for small kitchens.</p>
          </div>
        </div>

        {/* Email */}
        <label className="block text-[11px] font-semibold uppercase tracking-widest mb-1.5" style={{ color: th.labelFg }}>Email</label>
        <div className="flex items-center gap-2.5 rounded-2xl px-4 py-3.5 border mb-3" style={{ background: th.inputBg, borderColor: th.inputBorder }}>
          <Mail size={15} style={{ color: th.muted }} strokeWidth={2} />
          <input value={email} onChange={e => setEmail(e.target.value)} className="flex-1 text-[15px] outline-none bg-transparent" style={{ color: th.inputFg }} />
          <CheckCircle2 size={16} style={{ color: th.primary }} strokeWidth={2} />
        </div>

        {/* Password */}
        <label className="block text-[11px] font-semibold uppercase tracking-widest mb-1.5" style={{ color: th.labelFg }}>Password</label>
        <div className="flex items-center gap-2.5 rounded-2xl px-4 py-3.5 border mb-2" style={{ background: th.inputBg, borderColor: th.inputBorder }}>
          <Lock size={15} style={{ color: th.muted }} strokeWidth={2} />
          <input type={showPw ? "text" : "password"} defaultValue="ladle2024" className="flex-1 text-[15px] outline-none bg-transparent" style={{ color: th.inputFg }} />
          <button onClick={() => setShowPw(p => !p)} style={{ color: th.meta }}>{showPw ? <EyeOff size={16} strokeWidth={2} /> : <Eye size={16} strokeWidth={2} />}</button>
        </div>

        <div className="flex justify-end mb-6">
          <button onClick={() => navigate("forgot")} className="text-[12px] font-semibold transition-colors" style={{ color: th.meta }}>Forgot password?</button>
        </div>

        <button onClick={() => navigate("home")} className="w-full rounded-full py-4 text-[15px] font-bold tracking-wide mb-3 transition-all active:scale-[0.98]"
          style={{ background: th.primary, color: th.primaryFg, boxShadow: `0 6px 20px ${th.primary}44` }}>
          Sign in
        </button>

        <div className="flex items-center gap-3 mb-3">
          <div className="flex-1 h-px" style={{ background: th.border }} />
          <span className="text-[11px]" style={{ color: th.muted }}>or</span>
          <div className="flex-1 h-px" style={{ background: th.border }} />
        </div>

        <button onClick={() => navigate("home")} className="w-full rounded-full py-3.5 text-[14px] font-medium flex items-center justify-center gap-2.5 transition-all active:scale-[0.98] border"
          style={{ background: dark ? "#33291F" : "white", borderColor: th.inputBorder, color: th.body }}>
          <GoogleIcon /> Continue with Google
        </button>

        <p className="text-center text-[13px] mt-7" style={{ color: th.muted }}>
          New here?{" "}
          <button onClick={() => navigate("signup")} className="font-bold" style={{ color: th.meta }}>Join Ladle.</button>
        </p>
      </div>
    </div>
  );
}

// ─── Screen: Sign Up ──────────────────────────────────────────────────────────
function SignUpScreen({ dark, navigate }: { dark: boolean; navigate: (s: Screen) => void }) {
  const th = t(dark);
  const [showPw, setShowPw] = useState(false);
  return (
    <div className="flex-1 overflow-y-auto" style={{ scrollbarWidth: "none", background: th.bg }}>
      <div className="px-7 pt-5 pb-10 flex flex-col">
        <button onClick={() => navigate("signin")} className="flex items-center gap-1.5 mb-6 self-start" style={{ color: th.meta }}>
          <ChevronLeft size={18} strokeWidth={2.5} /><span className="text-[13px] font-semibold">Back</span>
        </button>
        <div className="flex flex-col items-center gap-2 mb-7">
          <div className={`w-14 h-14 rounded-2xl flex items-center justify-center ${th.logoRing}`}>
            <UtensilsCrossed size={26} color={th.logoIcon} strokeWidth={1.8} />
          </div>
          <h1 className="text-[28px] tracking-tight" style={{ fontFamily: "'Playfair Display', serif", fontWeight: 800, color: th.brandFg }}>Join Ladle</h1>
          <p className="text-[13px]" style={{ color: th.muted }}>Create your free account</p>
        </div>

        {[
          { label: "Full name", icon: User, type: "text", placeholder: "Maya Chen" },
          { label: "Email", icon: Mail, type: "email", placeholder: "maya@example.com" },
        ].map(({ label, icon: Icon, type, placeholder }) => (
          <div key={label} className="mb-3">
            <label className="block text-[11px] font-semibold uppercase tracking-widest mb-1.5" style={{ color: th.labelFg }}>{label}</label>
            <div className="flex items-center gap-2.5 rounded-2xl px-4 py-3.5 border" style={{ background: th.inputBg, borderColor: th.inputBorder }}>
              <Icon size={15} style={{ color: th.muted }} strokeWidth={2} />
              <input type={type} placeholder={placeholder} className="flex-1 text-[15px] outline-none bg-transparent" style={{ color: th.inputFg }} />
            </div>
          </div>
        ))}

        <div className="mb-6">
          <label className="block text-[11px] font-semibold uppercase tracking-widest mb-1.5" style={{ color: th.labelFg }}>Password</label>
          <div className="flex items-center gap-2.5 rounded-2xl px-4 py-3.5 border" style={{ background: th.inputBg, borderColor: th.inputBorder }}>
            <Lock size={15} style={{ color: th.muted }} strokeWidth={2} />
            <input type={showPw ? "text" : "password"} placeholder="Min. 8 characters" className="flex-1 text-[15px] outline-none bg-transparent" style={{ color: th.inputFg }} />
            <button onClick={() => setShowPw(p => !p)} style={{ color: th.meta }}>{showPw ? <EyeOff size={16} strokeWidth={2} /> : <Eye size={16} strokeWidth={2} />}</button>
          </div>
        </div>

        <button onClick={() => navigate("home")} className="w-full rounded-full py-4 text-[15px] font-bold mb-3 transition-all active:scale-[0.98]"
          style={{ background: th.primary, color: th.primaryFg, boxShadow: `0 6px 20px ${th.primary}44` }}>
          Create account
        </button>
        <button onClick={() => navigate("signin")} className="w-full rounded-full py-3.5 text-[14px] font-medium border transition-all"
          style={{ borderColor: th.inputBorder, color: th.meta, background: "transparent" }}>
          Already have an account?
        </button>
      </div>
    </div>
  );
}

// ─── Screen: Forgot Password ──────────────────────────────────────────────────
function ForgotScreen({ dark, navigate }: { dark: boolean; navigate: (s: Screen) => void }) {
  const th = t(dark);
  const [sent, setSent] = useState(false);
  return (
    <div className="flex-1 overflow-y-auto" style={{ scrollbarWidth: "none", background: th.bg }}>
      <div className="px-7 pt-5 pb-10 flex flex-col">
        <button onClick={() => navigate("signin")} className="flex items-center gap-1.5 mb-8 self-start" style={{ color: th.meta }}>
          <ChevronLeft size={18} strokeWidth={2.5} /><span className="text-[13px] font-semibold">Back to sign in</span>
        </button>

        <div className="mb-7">
          <div className="w-14 h-14 rounded-2xl flex items-center justify-center mb-4" style={{ background: th.inputBg }}>
            <Mail size={26} style={{ color: th.primary }} strokeWidth={1.8} />
          </div>
          <h1 className="text-[26px] mb-2" style={{ fontFamily: "'Playfair Display', serif", fontWeight: 800, color: th.heading }}>Reset password</h1>
          <p className="text-[13px] leading-relaxed" style={{ color: th.muted }}>{"Enter your email and we'll send a link to reset your password."}</p>
        </div>

        {sent ? (
          <div className="rounded-2xl p-5 mb-5 text-center border" style={{ background: th.successBg, borderColor: th.inputBorder }}>
            <CheckCircle2 size={32} className="mx-auto mb-3" style={{ color: th.primary }} strokeWidth={1.8} />
            <p className="text-[15px] font-bold mb-1" style={{ color: th.heading }}>Link sent!</p>
            <p className="text-[13px]" style={{ color: th.muted }}>Check your inbox at maya@example.com</p>
          </div>
        ) : (
          <>
            <label className="block text-[11px] font-semibold uppercase tracking-widest mb-1.5" style={{ color: th.labelFg }}>Email address</label>
            <div className="flex items-center gap-2.5 rounded-2xl px-4 py-3.5 border mb-5" style={{ background: th.inputBg, borderColor: th.inputBorder }}>
              <Mail size={15} style={{ color: th.muted }} strokeWidth={2} />
              <input type="email" defaultValue="maya@example.com" className="flex-1 text-[15px] outline-none bg-transparent" style={{ color: th.inputFg }} />
            </div>
            <button onClick={() => setSent(true)} className="w-full rounded-full py-4 text-[15px] font-bold mb-3 transition-all active:scale-[0.98]"
              style={{ background: th.primary, color: th.primaryFg, boxShadow: `0 6px 20px ${th.primary}44` }}>
              Send reset link
            </button>
          </>
        )}

        <button onClick={() => navigate("signin")} className="text-center text-[13px] font-semibold" style={{ color: th.meta }}>
          {sent ? "Back to sign in" : "Remember it? Sign in →"}
        </button>
      </div>
    </div>
  );
}

// ─── Screen: Home ─────────────────────────────────────────────────────────────
function HomeScreen({ dark, navigate, savedIds, toggleSave, likedIds, toggleLike, setRecipe }: {
  dark: boolean; navigate: (s: Screen) => void;
  savedIds: Set<string>; toggleSave: (id: string) => void;
  likedIds: Set<string>; toggleLike: (id: string) => void;
  setRecipe: (r: Recipe) => void;
}) {
  const th = t(dark);
  const [chip, setChip] = useState("Main course");

  const goRecipe = (r: Recipe) => { setRecipe(r); navigate("detail"); };

  return (
    <div className="flex-1 flex flex-col min-h-0">
      <div className="flex-1 overflow-y-auto" style={{ scrollbarWidth: "none", background: th.bg }}>

        {/* Header */}
        <div className="flex items-center justify-between px-5 pt-3 pb-3">
          <div>
            <p className="text-[11px] font-semibold" style={{ color: th.meta }}>Good evening,</p>
            <h2 className="text-[22px] leading-tight" style={{ fontFamily: "'Playfair Display', serif", fontWeight: 800, color: th.heading }}>Hey Maya 👋</h2>
          </div>
          <div className="flex items-center gap-2">
            <button onClick={() => navigate("search")} className="w-9 h-9 rounded-full flex items-center justify-center border transition-all active:scale-90"
              style={{ borderColor: th.border, background: th.inputBg }}>
              <Search size={16} style={{ color: th.meta }} strokeWidth={2} />
            </button>
            <button onClick={() => navigate("profile")} className="w-9 h-9 rounded-full flex items-center justify-center text-[13px] font-bold flex-shrink-0 transition-all active:scale-90"
              style={{ background: th.avatar, color: th.avatarFg }}>M</button>
          </div>
        </div>

        {/* Search bar */}
        <div className="px-5 mb-4">
          <button onClick={() => navigate("search")} className="w-full flex items-center gap-3 rounded-2xl px-4 py-3 border text-left"
            style={{ background: th.inputBg, borderColor: th.inputBorder }}>
            <Search size={16} style={{ color: th.muted }} strokeWidth={2} />
            <span className="text-[14px]" style={{ color: th.muted }}>{"What's in your fridge?"}</span>
          </button>
        </div>

        {/* Category chips */}
        <div className="flex gap-2 px-5 pb-4 overflow-x-auto" style={{ scrollbarWidth: "none" }}>
          {CATEGORIES.map(cat => (
            <button key={cat} onClick={() => setChip(cat)} className="flex-shrink-0 px-4 py-1.5 rounded-full text-[12px] font-semibold border transition-all"
              style={{ background: chip === cat ? th.chipActive : th.chipBg, borderColor: chip === cat ? th.chipActive : th.chipBorder, color: chip === cat ? th.chipActiveFg : th.chipFg }}>
              {cat}
            </button>
          ))}
        </div>

        {/* Tonight's picks */}
        <div className="px-5 mb-3 flex items-center justify-between">
          <h3 className="text-[16px] font-bold" style={{ fontFamily: "'Playfair Display', serif", color: th.heading }}>{"Tonight's picks"}</h3>
          <button onClick={() => navigate("search")} className="text-[12px] font-semibold" style={{ color: th.seeAll }}>See all</button>
        </div>
        <div className="flex gap-3 px-5 pb-5 overflow-x-auto" style={{ scrollbarWidth: "none" }}>
          {PICKS.map(r => (
            <RecipeCard key={r.id} recipe={r} dark={dark} saved={savedIds.has(r.id)} onSave={() => toggleSave(r.id)} onTap={() => goRecipe(r)} />
          ))}
        </div>

        {/* Banner */}
        <button onClick={() => navigate("search")} className="mx-5 mb-5 rounded-2xl overflow-hidden flex items-center justify-between px-5 py-4 w-[calc(100%-40px)] transition-all active:scale-[0.98]"
          style={{ background: th.bannerBg }}>
          <div className="text-left">
            <p className="text-[14px] font-bold text-white mb-0.5" style={{ fontFamily: "'Playfair Display', serif" }}>Cook with what you have</p>
            <p className="text-[11px] font-semibold" style={{ color: th.bannerAccent }}>Search by ingredients →</p>
          </div>
          <div className="w-9 h-9 rounded-full flex items-center justify-center flex-shrink-0" style={{ background: th.bannerAccent + "22" }}>
            <ArrowRight size={16} style={{ color: th.bannerAccent }} strokeWidth={2.5} />
          </div>
        </button>

        {/* Recommended */}
        <div className="px-5 mb-3 flex items-center justify-between">
          <h3 className="text-[16px] font-bold" style={{ fontFamily: "'Playfair Display', serif", color: th.heading }}>Recommended</h3>
          <button onClick={() => navigate("search")} className="text-[12px] font-semibold" style={{ color: th.seeAll }}>See all</button>
        </div>
        <div className="px-5 pb-6 flex flex-col gap-3">
          {RECOMMENDED.map(r => (
            <button key={r.id} onClick={() => goRecipe(r)} className="flex items-center gap-3 p-3 rounded-2xl border text-left transition-all active:scale-[0.98]"
              style={{ background: th.card, borderColor: th.cardBorder }}>
              <div className="w-14 h-14 rounded-xl overflow-hidden flex-shrink-0 bg-[#C4A0A9]">
                <img src={r.photo} alt={r.name} className="w-full h-full object-cover" />
              </div>
              <div className="flex-1 min-w-0">
                <p className="text-[14px] font-bold leading-tight mb-0.5 truncate" style={{ fontFamily: "'Playfair Display', serif", color: th.heading }}>{r.name}</p>
                <p className="text-[10px] font-medium" style={{ color: th.meta }}>{r.cat} · {r.time} · {r.by} · <span style={{ color: th.starFg }}>★</span>{r.rating}</p>
              </div>
              <button onClick={e => { e.stopPropagation(); toggleLike(r.id); }} className="flex-shrink-0 p-1">
                <Heart size={18} fill={likedIds.has(r.id) ? th.heartFill : "none"} style={{ color: likedIds.has(r.id) ? th.heartFill : th.muted }} strokeWidth={1.8} />
              </button>
            </button>
          ))}
        </div>
      </div>
      <BottomNav dark={dark} active="home" navigate={navigate} />
    </div>
  );
}

// ─── Screen: Search ───────────────────────────────────────────────────────────
function SearchScreen({ dark, navigate, savedIds, toggleSave, setRecipe }: {
  dark: boolean; navigate: (s: Screen) => void;
  savedIds: Set<string>; toggleSave: (id: string) => void;
  setRecipe: (r: Recipe) => void;
}) {
  const th = t(dark);
  const [query, setQuery] = useState("");
  const [chip, setChip] = useState("All");
  const inputRef = useRef<HTMLInputElement>(null);
  useEffect(() => { inputRef.current?.focus(); }, []);

  const cats = ["All", ...CATEGORIES.slice(0, 6)];
  const results = ALL_RECIPES.filter(r => {
    const matchQ = !query || r.name.toLowerCase().includes(query.toLowerCase()) || r.cat.toLowerCase().includes(query.toLowerCase());
    const matchC = chip === "All" || r.cat === chip;
    return matchQ && matchC;
  });

  const goRecipe = (r: Recipe) => { setRecipe(r); navigate("detail"); };

  return (
    <div className="flex-1 flex flex-col min-h-0">
      <div className="flex-1 overflow-y-auto" style={{ scrollbarWidth: "none", background: th.bg }}>
        <div className="px-5 pt-3 pb-3">
          <div className="flex items-center gap-3 rounded-2xl px-4 py-3 border" style={{ background: th.inputBg, borderColor: th.inputBorder }}>
            <Search size={16} style={{ color: th.meta }} strokeWidth={2} />
            <input ref={inputRef} value={query} onChange={e => setQuery(e.target.value)}
              placeholder="Search recipes, ingredients…" className="flex-1 text-[14px] outline-none bg-transparent" style={{ color: th.inputFg }} />
            {query && <button onClick={() => setQuery("")} style={{ color: th.muted }}><X size={15} strokeWidth={2} /></button>}
          </div>
        </div>

        <div className="flex gap-2 px-5 pb-4 overflow-x-auto" style={{ scrollbarWidth: "none" }}>
          {cats.map(c => (
            <button key={c} onClick={() => setChip(c)} className="flex-shrink-0 px-4 py-1.5 rounded-full text-[12px] font-semibold border transition-all"
              style={{ background: chip === c ? th.chipActive : th.chipBg, borderColor: chip === c ? th.chipActive : th.chipBorder, color: chip === c ? th.chipActiveFg : th.chipFg }}>
              {c}
            </button>
          ))}
        </div>

        <div className="px-5 mb-3">
          <p className="text-[12px] font-semibold" style={{ color: th.muted }}>{results.length} recipe{results.length !== 1 ? "s" : ""}</p>
        </div>

        <div className="flex flex-wrap gap-3 px-5 pb-6">
          {results.map(r => (
            <RecipeCard key={r.id} recipe={r} dark={dark} size="sm" saved={savedIds.has(r.id)} onSave={() => toggleSave(r.id)} onTap={() => goRecipe(r)} />
          ))}
          {results.length === 0 && (
            <div className="w-full text-center py-10">
              <p className="text-[32px] mb-2">🍳</p>
              <p className="text-[14px] font-semibold mb-1" style={{ color: th.heading }}>No recipes found</p>
              <p className="text-[12px]" style={{ color: th.muted }}>Try a different search</p>
            </div>
          )}
        </div>
      </div>
      <BottomNav dark={dark} active="search" navigate={navigate} />
    </div>
  );
}

// ─── Screen: Recipe Detail ────────────────────────────────────────────────────
function DetailScreen({ dark, navigate, recipe, savedIds, toggleSave, goBack }: {
  dark: boolean; navigate: (s: Screen) => void;
  recipe: Recipe; savedIds: Set<string>; toggleSave: (id: string) => void;
  goBack: () => void;
}) {
  const th = t(dark);
  const [showAll, setShowAll] = useState(false);
  const [timerOn, setTimerOn] = useState(false);
  const [addedList, setAddedList] = useState(false);
  const saved = savedIds.has(recipe.id);
  const visible = showAll ? INGREDIENTS : INGREDIENTS.slice(0, 3);

  return (
    <div className="flex-1 flex flex-col min-h-0">
      <div className="flex-1 overflow-y-auto" style={{ scrollbarWidth: "none", background: th.bg }}>

        {/* Hero */}
        <div className="relative h-[210px] bg-[#5C3A4D] flex-shrink-0">
          <img src={recipe.heroPhoto} alt={recipe.name} className="w-full h-full object-cover" />
          <div className="absolute inset-0" style={{ background: "linear-gradient(to bottom, rgba(0,0,0,0.4) 0%, transparent 55%)" }} />
          <div className="absolute top-3 left-4 right-4 flex justify-between items-center">
            <button onClick={goBack} className="w-8 h-8 rounded-full flex items-center justify-center transition-all active:scale-90" style={{ background: "rgba(0,0,0,0.4)" }}>
              <ChevronLeft size={18} color="white" strokeWidth={2.5} />
            </button>
            <button onClick={() => toggleSave(recipe.id)} className="w-8 h-8 rounded-full flex items-center justify-center transition-all active:scale-90" style={{ background: "rgba(0,0,0,0.4)" }}>
              <Bookmark size={15} fill={saved ? th.primary : "none"} color={saved ? th.primary : "white"} strokeWidth={2} />
            </button>
          </div>
        </div>

        <div className="px-5 pt-4 pb-6">
          {/* Title + rating */}
          <div className="flex items-start justify-between mb-3">
            <h1 className="text-[24px] leading-tight flex-1 pr-2" style={{ fontFamily: "'Playfair Display', serif", fontWeight: 800, color: th.heading }}>{recipe.name}</h1>
            <div className="flex items-center gap-1 flex-shrink-0 mt-1">
              <Star size={14} fill={th.starFg} style={{ color: th.starFg }} strokeWidth={0} />
              <span className="text-[14px] font-bold" style={{ color: th.starFg }}>{recipe.rating}</span>
            </div>
          </div>

          {/* Pills */}
          <div className="flex gap-2 mb-5 flex-wrap">
            {[{ icon: Clock, label: recipe.time }, { icon: Users, label: `Serves ${recipe.serves}` }, { icon: null, label: recipe.cat }].map(({ icon: Icon, label }) => (
              <div key={label} className="flex items-center gap-1.5 px-3 py-1.5 rounded-full border text-[12px] font-semibold" style={{ background: th.pill, borderColor: th.pillBorder, color: th.pillFg }}>
                {Icon && <Icon size={12} strokeWidth={2} />}{label}
              </div>
            ))}
          </div>

          {/* Ingredients */}
          <div className="rounded-2xl border overflow-hidden mb-4" style={{ background: th.card, borderColor: th.cardBorder }}>
            <div className="flex items-center justify-between px-4 py-3 border-b" style={{ borderColor: th.divider }}>
              <span className="text-[14px] font-bold" style={{ fontFamily: "'Playfair Display', serif", color: th.heading }}>Ingredients · 9</span>
              <button onClick={() => setAddedList(a => !a)} className="flex items-center gap-1 text-[11px] font-bold rounded-full px-3 py-1.5 transition-all"
                style={{ background: addedList ? th.primary : th.primary + "18", color: addedList ? th.primaryFg : th.primary }}>
                <ShoppingBasket size={11} strokeWidth={2} />{addedList ? "✓ Added" : "+ Add all to list"}
              </button>
            </div>
            {visible.map((ing, i) => (
              <div key={ing.name} className="flex items-center justify-between px-4 py-2.5" style={{ borderBottom: i < visible.length - 1 ? `1px solid ${th.divider}` : undefined }}>
                <span className="text-[13px]" style={{ color: th.body }}>{ing.name}</span>
                <span className="text-[13px] font-semibold" style={{ color: th.meta }}>{ing.amount}</span>
              </div>
            ))}
            {!showAll && (
              <button onClick={() => setShowAll(true)} className="w-full py-2.5 text-[12px] font-semibold text-center border-t" style={{ borderColor: th.divider, color: th.meta }}>
                See all 9 ingredients ↓
              </button>
            )}
          </div>

          {/* Guided Cook */}
          <div className="rounded-2xl p-4 mb-4" style={{ background: th.guidedBg }}>
            <div className="flex items-center justify-between mb-3">
              <div>
                <p className="text-[10px] font-bold uppercase tracking-widest mb-0.5" style={{ color: th.guidedFg, opacity: 0.6 }}>Guided Cook</p>
                <p className="text-[14px] font-bold" style={{ color: th.guidedFg, fontFamily: "'Playfair Display', serif" }}>Step 4 of 7</p>
              </div>
              <div className="flex items-center gap-1.5 px-3 py-1.5 rounded-full" style={{ background: th.timerBg }}>
                <Timer size={13} style={{ color: th.timerFg }} strokeWidth={2} />
                <span className="text-[13px] font-bold tabular-nums" style={{ color: th.timerFg }}>30:00</span>
              </div>
            </div>
            <p className="text-[14px] leading-snug mb-4" style={{ color: th.guidedFg, opacity: 0.9 }}>Simmer low and slow — 30 minutes, stir twice.</p>
            <button onClick={() => setTimerOn(r => !r)} className="flex items-center gap-2 px-5 py-2.5 rounded-full text-[13px] font-bold transition-all active:scale-[0.97]"
              style={{ background: th.guidedFg, color: th.guidedBg }}>
              {timerOn ? <><Pause size={13} fill={th.guidedBg} strokeWidth={0} />Pause timer</> : <><Play size={13} fill={th.guidedBg} strokeWidth={0} />Start timer ▶</>}
            </button>
          </div>

          {/* Review */}
          <div className="rounded-2xl p-4 border" style={{ background: th.reviewBg, borderColor: th.cardBorder }}>
            <div className="flex items-center gap-3 mb-2">
              <div className="w-9 h-9 rounded-full flex items-center justify-center text-[12px] font-bold flex-shrink-0" style={{ background: th.avatar, color: th.avatarFg }}>S</div>
              <div className="flex-1">
                <p className="text-[13px] font-bold leading-tight" style={{ color: th.heading }}>Sam T.</p>
                <div className="flex gap-0.5 mt-0.5">{[1,2,3,4,5].map(i => <Star key={i} size={10} fill={th.starFg} style={{ color: th.starFg }} strokeWidth={0} />)}</div>
              </div>
              <div className="w-10 h-10 rounded-lg overflow-hidden flex-shrink-0 bg-[#C4A0A9]">
                <img src={recipe.photo} alt="plate" className="w-full h-full object-cover" />
              </div>
            </div>
            <p className="text-[13px] leading-snug" style={{ color: th.body, opacity: 0.85 }}>"Rich and easy — attached a photo of my plate."</p>
          </div>
        </div>
      </div>
      <BottomNav dark={dark} active="home" navigate={navigate} />
    </div>
  );
}

// ─── Screen: Saved ────────────────────────────────────────────────────────────
function SavedScreen({ dark, navigate, savedIds, toggleSave, setRecipe }: {
  dark: boolean; navigate: (s: Screen) => void;
  savedIds: Set<string>; toggleSave: (id: string) => void;
  setRecipe: (r: Recipe) => void;
}) {
  const th = t(dark);
  const saved = ALL_RECIPES.filter(r => savedIds.has(r.id));
  const goRecipe = (r: Recipe) => { setRecipe(r); navigate("detail"); };

  return (
    <div className="flex-1 flex flex-col min-h-0">
      <div className="flex-1 overflow-y-auto" style={{ scrollbarWidth: "none", background: th.bg }}>
        <div className="px-5 pt-4 pb-2 flex items-center justify-between">
          <h2 className="text-[22px]" style={{ fontFamily: "'Playfair Display', serif", fontWeight: 800, color: th.heading }}>Saved</h2>
          <span className="text-[12px] font-semibold px-3 py-1 rounded-full" style={{ background: th.inputBg, color: th.meta }}>{saved.length} recipes</span>
        </div>

        {saved.length === 0 ? (
          <div className="flex flex-col items-center justify-center py-16 px-8 text-center">
            <span className="text-[40px] mb-3">🔖</span>
            <p className="text-[15px] font-bold mb-2" style={{ color: th.heading }}>Nothing saved yet</p>
            <p className="text-[13px] mb-5" style={{ color: th.muted }}>Tap the bookmark icon on any recipe to save it here.</p>
            <button onClick={() => navigate("home")} className="px-6 py-2.5 rounded-full text-[13px] font-bold" style={{ background: th.primary, color: th.primaryFg }}>Browse recipes</button>
          </div>
        ) : (
          <div className="flex flex-wrap gap-3 px-5 pt-3 pb-6">
            {saved.map(r => (
              <RecipeCard key={r.id} recipe={r} dark={dark} size="sm" saved={true} onSave={() => toggleSave(r.id)} onTap={() => goRecipe(r)} />
            ))}
          </div>
        )}
      </div>
      <BottomNav dark={dark} active="saved" navigate={navigate} />
    </div>
  );
}

// ─── Screen: Profile ──────────────────────────────────────────────────────────
function ProfileScreen({ dark, navigate, savedIds, setRecipe }: {
  dark: boolean; navigate: (s: Screen) => void;
  savedIds: Set<string>; setRecipe: (r: Recipe) => void;
}) {
  const th = t(dark);
  const recent = ALL_RECIPES.slice(0, 3);
  const goRecipe = (r: Recipe) => { setRecipe(r); navigate("detail"); };

  return (
    <div className="flex-1 flex flex-col min-h-0">
      <div className="flex-1 overflow-y-auto" style={{ scrollbarWidth: "none", background: th.bg }}>
        <div className="px-5 pt-4 pb-2 flex items-center justify-between">
          <h2 className="text-[22px]" style={{ fontFamily: "'Playfair Display', serif", fontWeight: 800, color: th.heading }}>Profile</h2>
          <button className="w-8 h-8 rounded-full flex items-center justify-center border" style={{ borderColor: th.border, background: th.inputBg }}>
            <Settings size={15} style={{ color: th.meta }} strokeWidth={2} />
          </button>
        </div>

        {/* Profile card */}
        <div className="mx-5 mt-2 mb-4 p-5 rounded-2xl border flex flex-col items-center text-center" style={{ background: th.card, borderColor: th.cardBorder }}>
          <div className="w-16 h-16 rounded-full flex items-center justify-center text-[22px] font-bold mb-3" style={{ background: th.avatar, color: th.avatarFg }}>M</div>
          <p className="text-[18px] font-bold mb-0.5" style={{ fontFamily: "'Playfair Display', serif", color: th.heading }}>Maya Chen</p>
          <p className="text-[12px] mb-4" style={{ color: th.muted }}>@mayacooks · Joined 2024</p>
          <div className="flex gap-4 w-full">
            {[
              { label: "Saved", value: savedIds.size, action: () => navigate("saved") },
              { label: "Cooked", value: 34 },
              { label: "Reviews", value: 12 },
            ].map(({ label, value, action }) => (
              <button key={label} onClick={action} className="flex-1 rounded-xl py-2.5 border" style={{ background: th.statsBg, borderColor: th.statsBorder }}>
                <p className="text-[18px] font-bold" style={{ color: th.heading }}>{value}</p>
                <p className="text-[10px] font-semibold" style={{ color: th.meta }}>{label}</p>
              </button>
            ))}
          </div>
        </div>

        {/* Tags */}
        <div className="px-5 mb-4">
          <p className="text-[12px] font-bold uppercase tracking-widest mb-2.5" style={{ color: th.muted }}>Favourite cuisines</p>
          <div className="flex flex-wrap gap-2">
            {["Italian", "Japanese", "Mediterranean", "Plant-based", "Quick eats"].map(tag => (
              <span key={tag} className="px-3 py-1 rounded-full text-[11px] font-semibold border" style={{ background: th.tagBg, borderColor: th.tagBorder, color: th.tagFg }}>{tag}</span>
            ))}
          </div>
        </div>

        {/* Recent */}
        <div className="px-5 mb-2 flex items-center justify-between">
          <p className="text-[14px] font-bold" style={{ fontFamily: "'Playfair Display', serif", color: th.heading }}>Recently cooked</p>
          <button onClick={() => navigate("search")} className="text-[12px] font-semibold" style={{ color: th.seeAll }}>See all</button>
        </div>
        <div className="px-5 pb-4 flex flex-col gap-2.5">
          {recent.map(r => (
            <button key={r.id} onClick={() => goRecipe(r)} className="flex items-center gap-3 p-3 rounded-2xl border text-left transition-all active:scale-[0.98]"
              style={{ background: th.card, borderColor: th.cardBorder }}>
              <div className="w-11 h-11 rounded-xl overflow-hidden flex-shrink-0 bg-[#C4A0A9]">
                <img src={r.photo} alt={r.name} className="w-full h-full object-cover" />
              </div>
              <div className="flex-1 min-w-0">
                <p className="text-[13px] font-bold truncate" style={{ fontFamily: "'Playfair Display', serif", color: th.heading }}>{r.name}</p>
                <p className="text-[10px]" style={{ color: th.meta }}>{r.cat} · {r.time} · <span style={{ color: th.starFg }}>★</span>{r.rating}</p>
              </div>
              <ChevronRight size={14} style={{ color: th.muted }} strokeWidth={2} />
            </button>
          ))}
        </div>

        {/* Sign out */}
        <div className="px-5 pb-6">
          <button onClick={() => navigate("signin")} className="w-full flex items-center justify-center gap-2 py-3 rounded-2xl border text-[13px] font-semibold transition-all active:scale-[0.98]"
            style={{ borderColor: th.inputBorder, color: th.muted, background: "transparent" }}>
            <LogOut size={15} strokeWidth={2} /> Sign out
          </button>
        </div>
      </div>
      <BottomNav dark={dark} active="profile" navigate={navigate} />
    </div>
  );
}

// ─── Phone frame ──────────────────────────────────────────────────────────────
function PhoneFrame({ dark, label, children }: { dark: boolean; label: string; children: React.ReactNode }) {
  const th = t(dark);
  return (
    <div className="flex flex-col items-center gap-3 flex-shrink-0">
      <span className="text-[10px] tracking-[0.25em] uppercase text-white/25 font-semibold">{label}</span>
      <div className={`relative w-[340px] h-[680px] rounded-[44px] overflow-hidden flex flex-col ${th.frameBorder} ${th.frameExtra}`}
        style={{ fontFamily: "'DM Sans', sans-serif" }}>
        <StatusBar dark={dark} />
        {children}
      </div>
    </div>
  );
}

// ─── App shell ────────────────────────────────────────────────────────────────
const JUMP_TABS: { id: Screen; label: string }[] = [
  { id: "signin",  label: "Sign In" },
  { id: "home",    label: "Home" },
  { id: "search",  label: "Search" },
  { id: "saved",   label: "Saved" },
  { id: "profile", label: "Profile" },
  { id: "detail",  label: "Recipe" },
];

export default function App() {
  const [screen, setScreen] = useState<Screen>("home");
  const [history, setHistory] = useState<Screen[]>(["home"]);
  const [recipe, setRecipe] = useState<Recipe>(ALL_RECIPES[0]);
  const [savedIds, setSavedIds] = useState<Set<string>>(new Set(["pancakes", "ragu"]));
  const [likedIds, setLikedIds] = useState<Set<string>>(new Set());

  const navigate = (s: Screen) => {
    setHistory(h => [...h, s]);
    setScreen(s);
  };

  const goBack = () => {
    if (history.length > 1) {
      const next = history.slice(0, -1);
      setHistory(next);
      setScreen(next[next.length - 1]);
    } else {
      navigate("home");
    }
  };

  const jumpTo = (s: Screen) => {
    setHistory([s]);
    setScreen(s);
    if (s === "detail") setRecipe(ALL_RECIPES[0]);
  };

  const toggleSave = (id: string) =>
    setSavedIds(s => { const n = new Set(s); n.has(id) ? n.delete(id) : n.add(id); return n; });

  const toggleLike = (id: string) =>
    setLikedIds(s => { const n = new Set(s); n.has(id) ? n.delete(id) : n.add(id); return n; });

  const screenProps = { navigate, goBack, savedIds, toggleSave, likedIds, toggleLike, recipe, setRecipe };

  function renderScreen(dark: boolean) {
    const p = { ...screenProps, dark };
    switch (screen) {
      case "signin":  return <SignInScreen {...p} />;
      case "signup":  return <SignUpScreen {...p} />;
      case "forgot":  return <ForgotScreen {...p} />;
      case "home":    return <HomeScreen {...p} />;
      case "search":  return <SearchScreen {...p} />;
      case "detail":  return <DetailScreen {...p} recipe={recipe} />;
      case "saved":   return <SavedScreen {...p} />;
      case "profile": return <ProfileScreen {...p} />;
    }
  }

  return (
    <div className="min-h-screen w-full flex flex-col items-center py-12 px-6 gap-8"
      style={{ background: "linear-gradient(135deg, #2D1F2D 0%, #1A1210 50%, #2D1F1A 100%)", fontFamily: "'DM Sans', sans-serif" }}>

      <div className="text-center">
        <h1 className="text-white/80 text-[28px] mb-1" style={{ fontFamily: "'Playfair Display', serif", fontWeight: 800 }}>Ladle</h1>
        <p className="text-white/30 text-[11px] tracking-widest uppercase">Mobile Design · Light &amp; Dark</p>
      </div>

      {/* Jump tabs */}
      <div className="flex flex-wrap justify-center gap-1 p-1 rounded-2xl" style={{ background: "rgba(255,255,255,0.07)" }}>
        {JUMP_TABS.map(({ id, label }) => (
          <button key={id} onClick={() => jumpTo(id)}
            className="px-4 py-1.5 rounded-xl text-[12px] font-semibold transition-all"
            style={{ background: screen === id ? "rgba(255,255,255,0.18)" : "transparent", color: screen === id ? "white" : "rgba(255,255,255,0.38)" }}>
            {label}
          </button>
        ))}
      </div>

      {/* Phones */}
      <div className="flex flex-col lg:flex-row items-start justify-center gap-10 lg:gap-12">
        <PhoneFrame dark={false} label="Deep Plum & Blush">{renderScreen(false)}</PhoneFrame>
        <PhoneFrame dark={true}  label="Terracotta Night">{renderScreen(true)}</PhoneFrame>
      </div>

      <p className="text-white/20 text-[11px] tracking-widest uppercase">Big flavour for small kitchens.</p>
    </div>
  );
}
