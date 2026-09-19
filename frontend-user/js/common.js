/* ========== API & Auth ========== */
const API = (window.location.port === '8083' || window.location.port === '80' || window.location.port === '') && window.location.protocol !== 'file:'
    ? '' : 'http://localhost:8089';

async function api(path) {
    const res = await fetch(API + path, { credentials: 'include' });
    const data = await res.json();
    if (data.code === 401) { clearUser(); showToast('请先登录', 'error'); setTimeout(() => location.href = 'login.html', 1000); return null; }
    if (data.code !== 200) { showToast(data.msg || '请求失败', 'error'); return null; }
    return (data.data !== null && data.data !== undefined) ? data.data : true;
}

function showConfirm(msg, onOk) {
    const id = 'cfm' + Date.now();
    const div = document.createElement('div');
    div.className = 'modal-overlay show';
    div.id = id;
    div.innerHTML =
        '<div class="modal confirm-modal">' +
            '<div class="confirm-icon"><i class="fas fa-exclamation-circle"></i></div>' +
            '<div class="confirm-msg">' + msg + '</div>' +
            '<div class="confirm-btns">' +
                '<button class="btn btn-outline" id="' + id + 'c">取消</button>' +
                '<button class="btn btn-primary" id="' + id + 'k">确认</button>' +
            '</div>' +
        '</div>';
    document.body.appendChild(div);
    document.getElementById(id + 'c').onclick = () => div.remove();
    document.getElementById(id + 'k').onclick = () => { div.remove(); onOk && onOk(); };
    div.onclick = (e) => { if (e.target === div) div.remove(); };
}

async function apiRaw(path) {
    const res = await fetch(API + path, { credentials: 'include' });
    return await res.json();
}

function getParam(k) { return new URLSearchParams(location.search).get(k); }

/* ========== Session ========== */
function saveUser(u) { localStorage.setItem('user', JSON.stringify(u)); }
function getUser() { try { return JSON.parse(localStorage.getItem('user')); } catch { return null; } }
function clearUser() { localStorage.removeItem('user'); }
function requireLogin() { if (!getUser()) { location.href = 'login.html'; return false; } return true; }

/* ========== i18n ========== */
const LANG = {
    zh: { home:'首页',spots:'景点',routes:'线路',culture:'红色文化',hotels:'酒店',foods:'美食',faq:'客服',login:'登录',register:'注册',logout:'退出',profile:'个人中心',favorites:'我的收藏',orders:'我的订单',messages:'消息',stamps:'我的集章',search:'搜索',more:'查看更多',price:'价格',free:'免费',day:'天',book:'预订',collect:'收藏',collected:'已收藏',like:'点赞',liked:'已赞',comment:'评论',submit:'提交',cancel:'取消',pay:'支付',refund:'退款',allRegions:'全部地区',allThemes:'全部主题',hotSpots:'热门景点',recommendRoutes:'推荐线路',cultureStories:'红色故事',noData:'暂无数据',loading:'加载中...',
        spotDetail:'景点详情',routeDetail:'线路详情',cultureDetail:'文化详情',hotelDetail:'酒店详情',foodDetail:'美食详情',
        bookTicket:'预订门票',bookRoute:'预订线路',bookHotel:'预订酒店',buyFood:'购买美食',
        confirmPay:'确认支付',paySuccess:'支付成功',orderAmount:'订单金额',wechatPay:'微信支付',bankPay:'银行卡支付',payLater:'稍后支付',
        quantity:'数量',totalCost:'费用合计',visitDate:'参观日期',departDate:'出发日期',checkIn:'入住日期',checkOut:'退房日期',travelers:'出行人数',rooms:'房间数量',
        viewOnMap:'在地图中查看',location:'位置',openTime:'开放时间',ticketPrice:'门票价格',traffic:'交通指南',
        historyBg:'历史背景',revolutionEvent:'革命事件',personStory:'人物故事',gallery:'图片展示',relatedSpots:'相关景点',
        rating:'评分',views:'浏览量',days:'天数',theme:'主题',budget:'预算',
        writeComment:'发表评论',commentPlaceholder:'写下你的评价...',
        nickname:'昵称',phone:'手机号',password:'密码',oldPassword:'旧密码',newPassword:'新密码',confirmPassword:'确认密码',save:'保存',
        username:'用户名',rememberMe:'记住我',forgotPassword:'忘记密码',noAccount:'没有账号？',hasAccount:'已有账号？',goRegister:'去注册',goLogin:'去登录',
        cancelOrder:'取消订单',refundOrder:'申请退款',orderStatus:'订单状态',orderType:'订单类型',
        all:'全部',pending:'待支付',paid:'已支付',cancelled:'已取消',refunded:'已退款',
        faqTitle:'智能客服',faqPlaceholder:'请输入您的问题...',send:'发送',
        editProfile:'编辑资料',changePassword:'修改密码',myFavorites:'我的收藏',myOrders:'我的订单',myMessages:'消息通知',
        share:'分享',copyLink:'复制链接',copied:'已复制',
        confirmCancel:'确定取消该订单？',confirmRefund:'确定申请退款？',
        loginFirst:'请先登录',loginSuccess:'登录成功',registerSuccess:'注册成功',
        footer:'© 2026 贵州红色文化旅游景点信息管理系统'
    },
    en: { home:'Home',spots:'Spots',routes:'Routes',culture:'Red Culture',hotels:'Hotels',foods:'Food',faq:'Support',login:'Login',register:'Register',logout:'Logout',profile:'Profile',favorites:'Favorites',orders:'Orders',messages:'Messages',stamps:'My Stamps',search:'Search',more:'More',price:'Price',free:'Free',day:'Day(s)',book:'Book',collect:'Collect',collected:'Collected',like:'Like',liked:'Liked',comment:'Comment',submit:'Submit',cancel:'Cancel',pay:'Pay',refund:'Refund',allRegions:'All Regions',allThemes:'All Themes',hotSpots:'Hot Spots',recommendRoutes:'Recommended Routes',cultureStories:'Red Stories',noData:'No Data',loading:'Loading...',
        spotDetail:'Spot Detail',routeDetail:'Route Detail',cultureDetail:'Culture Detail',hotelDetail:'Hotel Detail',foodDetail:'Food Detail',
        bookTicket:'Book Ticket',bookRoute:'Book Route',bookHotel:'Book Hotel',buyFood:'Buy Food',
        confirmPay:'Confirm Payment',paySuccess:'Payment Successful',orderAmount:'Order Amount',wechatPay:'WeChat Pay',bankPay:'Bank Card',payLater:'Pay Later',
        quantity:'Quantity',totalCost:'Total Cost',visitDate:'Visit Date',departDate:'Departure Date',checkIn:'Check-in',checkOut:'Check-out',travelers:'Travelers',rooms:'Rooms',
        viewOnMap:'View on Map',location:'Location',openTime:'Opening Hours',ticketPrice:'Ticket Price',traffic:'Transportation',
        historyBg:'Historical Background',revolutionEvent:'Revolutionary Events',personStory:'Personal Stories',gallery:'Gallery',relatedSpots:'Related Spots',
        rating:'Rating',views:'Views',days:'Days',theme:'Theme',budget:'Budget',
        writeComment:'Write a Review',commentPlaceholder:'Share your experience...',
        nickname:'Nickname',phone:'Phone',password:'Password',oldPassword:'Old Password',newPassword:'New Password',confirmPassword:'Confirm Password',save:'Save',
        username:'Username',rememberMe:'Remember Me',forgotPassword:'Forgot Password',noAccount:'No account?',hasAccount:'Have an account?',goRegister:'Register',goLogin:'Login',
        cancelOrder:'Cancel Order',refundOrder:'Request Refund',orderStatus:'Status',orderType:'Type',
        all:'All',pending:'Pending',paid:'Paid',cancelled:'Cancelled',refunded:'Refunded',
        faqTitle:'Smart Assistant',faqPlaceholder:'Type your question...',send:'Send',
        editProfile:'Edit Profile',changePassword:'Change Password',myFavorites:'My Favorites',myOrders:'My Orders',myMessages:'Notifications',
        share:'Share',copyLink:'Copy Link',copied:'Copied',
        confirmCancel:'Cancel this order?',confirmRefund:'Request refund?',
        loginFirst:'Please login first',loginSuccess:'Login successful',registerSuccess:'Registration successful',
        footer:'© 2026 Guizhou Red Culture Tourism System'
    },
    ja: { home:'ホーム',spots:'観光地',routes:'ルート',culture:'赤い文化',hotels:'ホテル',foods:'グルメ',faq:'サポート',login:'ログイン',register:'登録',logout:'ログアウト',profile:'プロフィール',favorites:'お気に入り',orders:'注文',messages:'メッセージ',stamps:'マイスタンプ',search:'検索',more:'もっと見る',price:'価格',free:'無料',day:'日',book:'予約',collect:'保存',collected:'保存済',like:'いいね',liked:'いいね済',comment:'コメント',submit:'送信',cancel:'キャンセル',pay:'支払',refund:'返金',allRegions:'全地域',allThemes:'全テーマ',hotSpots:'人気観光地',recommendRoutes:'おすすめルート',cultureStories:'赤い物語',noData:'データなし',loading:'読み込み中...',
        spotDetail:'観光地詳細',routeDetail:'ルート詳細',cultureDetail:'文化詳細',hotelDetail:'ホテル詳細',foodDetail:'グルメ詳細',
        bookTicket:'チケット予約',bookRoute:'ルート予約',bookHotel:'ホテル予約',buyFood:'グルメ購入',
        confirmPay:'支払い確認',paySuccess:'支払い完了',orderAmount:'注文金額',wechatPay:'WeChat Pay',bankPay:'銀行カード',payLater:'後で支払う',
        quantity:'数量',totalCost:'合計金額',visitDate:'訪問日',departDate:'出発日',checkIn:'チェックイン',checkOut:'チェックアウト',travelers:'人数',rooms:'部屋数',
        viewOnMap:'地図で見る',location:'場所',openTime:'営業時間',ticketPrice:'入場料',traffic:'交通案内',
        historyBg:'歴史的背景',revolutionEvent:'革命的出来事',personStory:'人物物語',gallery:'ギャラリー',relatedSpots:'関連観光地',
        rating:'評価',views:'閲覧数',days:'日数',theme:'テーマ',budget:'予算',
        writeComment:'レビューを書く',commentPlaceholder:'体験を共有...',
        nickname:'ニックネーム',phone:'電話番号',password:'パスワード',oldPassword:'旧パスワード',newPassword:'新パスワード',confirmPassword:'パスワード確認',save:'保存',
        username:'ユーザー名',rememberMe:'ログイン状態を保持',forgotPassword:'パスワードを忘れた',noAccount:'アカウントがない？',hasAccount:'アカウントをお持ち？',goRegister:'登録する',goLogin:'ログインする',
        cancelOrder:'注文キャンセル',refundOrder:'返金申請',orderStatus:'ステータス',orderType:'種類',
        all:'全て',pending:'未払い',paid:'支払済',cancelled:'キャンセル済',refunded:'返金済',
        faqTitle:'スマートアシスタント',faqPlaceholder:'質問を入力...',send:'送信',
        editProfile:'プロフィール編集',changePassword:'パスワード変更',myFavorites:'お気に入り',myOrders:'注文履歴',myMessages:'通知',
        share:'共有',copyLink:'リンクをコピー',copied:'コピー済',
        confirmCancel:'この注文をキャンセルしますか？',confirmRefund:'返金を申請しますか？',
        loginFirst:'ログインしてください',loginSuccess:'ログイン成功',registerSuccess:'登録成功',
        footer:'© 2026 貴州赤色文化観光管理システム'
    }
};
let currentLang = localStorage.getItem('lang') || 'zh';
function t(key) { return (LANG[currentLang] || LANG.zh)[key] || key; }
function switchLang(lang) {
    currentLang = lang; localStorage.setItem('lang', lang);
    document.querySelectorAll('[data-i18n]').forEach(el => { el.textContent = t(el.dataset.i18n); });
    document.querySelectorAll('[data-i18n-placeholder]').forEach(el => { el.placeholder = t(el.dataset.i18nPlaceholder); });
    const sel = document.getElementById('langSelect'); if (sel) sel.value = lang;
    // 触发全局语言变更事件，供各页面刷新业务数据内容
    document.dispatchEvent(new CustomEvent('langchange', { detail: lang }));
}

/**
 * 从业务数据对象中获取当前语言的字段值。
 * 例如 getLang(spot, 'name') 在英文环境下返回 spot.nameEn（若有），否则回退到 spot.name。
 */
function getLang(obj, field) {
    if (!obj) return '';
    if (currentLang !== 'zh') {
        const suffix = currentLang.charAt(0).toUpperCase() + currentLang.slice(1); // En / Ja
        const val = obj[field + suffix];
        if (val) return val;
    }
    return obj[field] || '';
}

/* ========== UI Helpers ========== */
function showToast(msg, type = 'success') {
    let c = document.querySelector('.toast-container');
    if (!c) { c = document.createElement('div'); c.className = 'toast-container'; document.body.appendChild(c); }
    const d = document.createElement('div');
    d.className = 'toast toast-' + type;
    d.innerHTML = '<i class="fas fa-' + (type === 'success' ? 'check-circle' : type === 'error' ? 'times-circle' : 'exclamation-circle') + '"></i>' + msg;
    c.appendChild(d);
    setTimeout(() => { d.style.opacity = '0'; d.style.transform = 'translateX(100%)'; setTimeout(() => d.remove(), 300); }, 3000);
}

function imgError(img) {
    img.onerror = null;
    img.style.display = 'none';
    if (img.parentElement) img.parentElement.innerHTML = '<div style="width:100%;height:100%;background:linear-gradient(135deg,#C41A1A,#8B1A1A);display:flex;align-items:center;justify-content:center;color:rgba(255,255,255,.4);font-size:40px"><i class="fas fa-image"></i></div>';
}

function renderPagination(container, current, total, pageSize, onClick) {
    const pages = Math.ceil(total / pageSize);
    if (pages <= 1) { container.innerHTML = ''; return; }
    let html = '';
    if (current > 1) html += '<a onclick="' + onClick + '(' + (current - 1) + ')"><i class="fas fa-chevron-left"></i></a>';
    for (let i = 1; i <= pages; i++) {
        if (i === 1 || i === pages || (i >= current - 2 && i <= current + 2)) {
            html += current === i ? '<span class="active">' + i + '</span>' : '<a onclick="' + onClick + '(' + i + ')">' + i + '</a>';
        } else if (i === current - 3 || i === current + 3) html += '<span class="disabled">...</span>';
    }
    if (current < pages) html += '<a onclick="' + onClick + '(' + (current + 1) + ')"><i class="fas fa-chevron-right"></i></a>';
    container.innerHTML = html;
}

function formatDate(d) {
    if (!d) return '';
    if (typeof d === 'number') {
        var dt = new Date(d);
        var y = dt.getFullYear(), m = ('0'+(dt.getMonth()+1)).slice(-2), day = ('0'+dt.getDate()).slice(-2);
        var h = ('0'+dt.getHours()).slice(-2), min = ('0'+dt.getMinutes()).slice(-2);
        return y+'-'+m+'-'+day+' '+h+':'+min;
    }
    return typeof d === 'string' ? d.substring(0, 16) : '';
}

/* ========== Header Render ========== */
function renderHeader() {
    const user = getUser();
    const um = document.getElementById('userMenu');
    if (!um) return;
    if (user) {
        const initial = (user.nickname || user.username || '').charAt(0).toUpperCase();
        let avatarHtml = initial;
        if (user.avatar) {
            avatarHtml = '<img src="' + API + user.avatar + '" style="width:100%;height:100%;object-fit:cover;border-radius:50%" onerror="this.parentElement.textContent=\'' + initial + '\'">';
        }
        um.innerHTML = '<div class="user-dropdown"><div class="user-avatar-small" onclick="this.parentElement.querySelector(\'.dropdown-menu\').classList.toggle(\'show\')">' + avatarHtml + '</div><div class="dropdown-menu"><a href="profile.html"><i class="fas fa-user"></i> ' + t('profile') + '</a><a href="stamps.html"><i class="fas fa-stamp"></i> ' + t('stamps') + '</a><a href="favorites.html"><i class="fas fa-heart"></i> ' + t('favorites') + '</a><a href="orders.html"><i class="fas fa-shopping-bag"></i> ' + t('orders') + '</a><a href="messages.html"><i class="fas fa-bell"></i> ' + t('messages') + '</a><a href="#" onclick="doLogout()"><i class="fas fa-sign-out-alt"></i> ' + t('logout') + '</a></div></div>';
    } else {
        um.innerHTML = '<a href="login.html" class="btn btn-primary btn-sm">' + t('login') + '</a>';
    }
    const sel = document.getElementById('langSelect'); if (sel) sel.value = currentLang;
}

async function doLogout() {
    await api('/api/auth/logout');
    clearUser();
    showToast('已退出登录');
    setTimeout(() => location.href = 'index.html', 500);
}

/* ========== Stars ========== */
function renderStars(rating, max = 5) {
    let s = '';
    for (let i = 1; i <= max; i++) s += '<i class="fas fa-star" style="color:' + (i <= rating ? '#FFD700' : '#ddd') + '"></i>';
    return s;
}

/** 给业务 API 路径自动附加 lang 参数 */
function withLang(path) {
    if (!currentLang || currentLang === 'zh') return path;
    return path + (path.includes('?') ? '&' : '?') + 'lang=' + currentLang;
}

/** Session 超时检测：5分钟检查一次 */
function startSessionWatcher() {
    const user = getUser();
    if (!user) return;
    setInterval(async () => {
        try {
            const res = await fetch(API + '/api/auth/currentUser', { credentials: 'include' });
            const data = await res.json();
            if (data.code === 401) {
                clearUser();
                showToast('登录已超时，请重新登录', 'warning');
                setTimeout(() => location.href = 'login.html', 1200);
            }
        } catch (e) {}
    }, 300000);
}

/* ========== Init ========== */
document.addEventListener('DOMContentLoaded', () => {
    renderHeader();
    switchLang(currentLang);
    startSessionWatcher();
    document.addEventListener('click', e => {
        if (!e.target.closest('.user-dropdown')) document.querySelectorAll('.dropdown-menu').forEach(m => m.classList.remove('show'));
    });
});
