SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

USE red_tourism;

-- 管理员账号
INSERT INTO sys_user (username, password, phone, nickname, role, status) VALUES
('admin', 'admin123', '13800000000', '系统管理员', 'ADMIN', 1);

-- 测试游客账号
INSERT INTO sys_user (username, password, phone, nickname, role, status) VALUES
('zhangsan', '123456', '13900000001', '张三', 'USER', 1),
('lisi', '123456', '13900000002', '李四', 'USER', 1),
('user1', '123456', '13900000003', '红色旅行者', 'USER', 1);

-- 测试工作人员账号（仅可操作所属景点）
INSERT INTO sys_user (username, password, phone, nickname, role, status) VALUES
('staff1', '123456', '13900000011', '景点工作人员A', 'STAFF', 1),
('staff2', '123456', '13900000012', '景点工作人员B', 'STAFF', 1);

-- 景点数据（staff_id：5=staff1，6=staff2）
INSERT INTO scenic_spot (name, description, location, region, theme, open_time, ticket_price, traffic_info, history_background, revolution_event, person_story, cover_image, status, view_count, staff_id, longitude, latitude, ticket_reservation, suggested_duration, items_to_bring) VALUES
('遵义会议会址', '遵义会议会址位于遵义市红花岗区子尹路96号，是全国重点文物保护单位，全国红色旅游经典景区。', '贵州省遵义市红花岗区子尹路96号', '遵义市', '革命遗址', '08:30-17:00', 0.00, '遵义市区公交可达，距遵义站约3公里', '1935年1月，中共中央在此召开政治局扩大会议，确立了毛泽东在党中央和红军中的领导地位。', '遵义会议是中国共产党历史上一次生死攸关的转折点，挽救了党、挽救了红军、挽救了中国革命。', '毛泽东、周恩来、朱德、王稼祥等老一辈无产阶级革命家在此作出了伟大的历史抉择。', '/uploads/spot_zunyi.jpg', 1, 15820, 5, 106.7135, 27.7254, '免费参观，需提前通过官方微信公众号预约，凭身份证入馆。周一闭馆（法定节假日除外）。', '建议停留2-3小时', '身份证原件、口罩、舒适步行鞋、遮阳帽、相机、充电宝'),
('息烽集中营革命历史纪念馆', '息烽集中营是抗战时期国民党军统设立的规模最大、等级最高的秘密监狱。', '贵州省贵阳市息烽县永靖镇', '贵阳市', '纪念馆', '09:00-17:00', 0.00, '贵阳出发沿贵遵高速约70公里', '息烽集中营先后关押了1200多人，其中600多人被秘密杀害。许多共产党人和爱国志士在此英勇斗争。', '罗世文、车耀先、张露萍等革命先烈在此坚持斗争，展现了共产党人坚贞不屈的革命精神。', '张露萍，年仅24岁的女共产党员，在集中营中坚持地下斗争，最终英勇就义。', '/uploads/spot_xifeng.jpg', 1, 8930, 5, 106.7380, 27.0944, '免费参观，凭身份证在入口处领票。建议提前1天电话确认开放情况。', '建议停留1.5-2小时', '身份证原件、饮用水、雨伞、舒适步行鞋、纸巾'),
('四渡赤水纪念馆', '位于习水县土城镇，全面展示了红军四渡赤水的光辉历程。', '贵州省遵义市习水县土城镇', '遵义市', '战役遗址', '09:00-17:00', 0.00, '从遵义出发约3小时车程', '四渡赤水战役是遵义会议后毛泽东指挥的第一个战役，是红军长征中最精彩的军事行动。', '1935年1月至3月，红军在川黔滇边境四次飞渡赤水河，成功摆脱了国民党40万大军的围追堵截。', '毛泽东运用灵活机动的战略战术，创造了以少胜多、变被动为主动的光辉战例。', '/uploads/spot_chishui.jpg', 1, 12450, 5, 105.9913, 28.4567, '免费参观，凭身份证登记入馆。旺季建议提前预约。', '建议停留2-2.5小时', '身份证原件、晕车药、瓶装水、防晒用品、舒适运动鞋'),
('娄山关战斗遗址', '娄山关是川黔交通要道上的重要关口，红军曾两次攻克娄山关。', '贵州省遵义市汇川区板桥镇', '遵义市', '战役遗址', '全天开放', 0.00, '遵义市区驱车约50分钟', '娄山关地势险要，自古以来是兵家必争之地。1935年红军两次攻克娄山关，取得了长征以来的首次大捷。', '1935年2月，红军在此取得了长征以来的第一个大胜利，毛泽东写下了著名的《忆秦娥·娄山关》。', '毛泽东亲自指挥战斗，并在胜利后写下"雄关漫道真如铁，而今迈步从头越"的豪迈诗句。', '/uploads/spot_loushan.jpg', 1, 9870, 5, 106.8130, 27.9100, '户外景区无需预约，免费开放。如遇恶劣天气可能临时关闭，请关注天气。', '建议停留1.5-2小时', '身份证原件、保暖外套（山区风大）、防滑登山鞋、手机、雨伞'),
('黎平会议会址', '黎平会议是红军长征途中的一次重要会议，为遵义会议的召开奠定了基础。', '贵州省黔东南州黎平县翘街', '黔东南州', '革命遗址', '08:30-17:30', 0.00, '从贵阳出发约5小时车程', '1934年12月，中共中央在黎平召开政治局会议，确定了向贵州转兵的战略方针。', '黎平会议否定了博古、李德的错误军事路线，为遵义会议的召开做了重要准备。', '周恩来主持会议，毛泽东的正确主张开始被更多人接受。', '/uploads/spot_liping.jpg', 1, 6540, 6, 109.1362, 26.2311, '免费参观，凭身份证在入口领票。团体参观需提前3天预约讲解。', '建议停留1.5-2小时', '身份证原件、驱蚊水、防晒用品、舒适步行鞋、相机'),
('猴场会议会址', '猴场会议被周恩来称为"伟大转折的前夜"。', '贵州省黔南州瓮安县猴场镇', '黔南州', '革命遗址', '09:00-17:00', 0.00, '从贵阳出发约2.5小时车程', '1934年底至1935年初，红军在猴场召开政治局会议，为抢渡乌江、攻占遵义作了准备。', '猴场会议进一步确定了毛泽东提出的战略方针，为遵义会议的成功召开铺平了道路。', '刘伯承等军事领导在此研究渡江方案，展现了卓越的军事才能。', '/uploads/spot_houchang.jpg', 1, 4320, 6, 107.4754, 27.0685, '免费参观，凭身份证登记入内。每周一闭馆（节假日顺延）。', '建议停留1-1.5小时', '身份证原件、瓶装水、纸巾、充电宝、舒适步行鞋'),
('王若飞故居', '王若飞故居是全国爱国主义教育示范基地，纪念杰出的共产主义战士王若飞。', '贵州省安顺市西秀区', '安顺市', '伟人故居', '09:00-17:00', 0.00, '安顺市区公交可达', '王若飞是贵州安顺人，是杰出的共产主义战士、中共早期领导人之一。', '王若飞积极参加抗日民族统一战线工作，为中国革命事业作出了重大贡献。', '王若飞一生为革命奔波，"一切要为人民打算"是他的座右铭，1946年因飞机失事不幸遇难。', '/uploads/spot_wangruofei.jpg', 1, 5670, 6, 105.9473, 26.2456, '免费开放，凭身份证入馆。如需讲解服务可现场预约。', '建议停留1-1.5小时', '身份证原件、口罩、遮阳伞、手机、笔记本'),
('红军山烈士陵园', '红军山烈士陵园是为纪念红军长征在遵义牺牲的革命先烈而建。', '贵州省遵义市红花岗区凤凰山', '遵义市', '纪念馆', '全天开放', 0.00, '遵义市区步行可达', '陵园内安葬着红军烈士遗骨，并有红军卫生员龙思泉的铜像。', '红三军团参谋长邓萍在攻占遵义的战斗中英勇牺牲，安葬于此。', '邓萍是红军长征中牺牲的最高级别将领之一，年仅27岁。', '/uploads/spot_hongjunshan.jpg', 1, 7890, 6, 106.7234, 27.7300, '开放式陵园，无需预约。建议保持肃穆，文明祭扫。', '建议停留1-1.5小时', '身份证原件、水、纸巾、舒适步行鞋、遮阳帽');

-- 景点图片
INSERT INTO scenic_spot_image (spot_id, image_url, sort_order) VALUES
(1, '/uploads/spot_zunyi_1.jpg', 1),
(1, '/uploads/spot_zunyi_2.jpg', 2),
(1, '/uploads/spot_zunyi_3.jpg', 3),
(2, '/uploads/spot_xifeng_1.jpg', 1),
(2, '/uploads/spot_xifeng_2.jpg', 2),
(3, '/uploads/spot_chishui_1.jpg', 1),
(3, '/uploads/spot_chishui_2.jpg', 2),
(4, '/uploads/spot_loushan_1.jpg', 1),
(5, '/uploads/spot_liping_1.jpg', 1),
(6, '/uploads/spot_houchang_1.jpg', 1),
(7, '/uploads/spot_wangruofei_1.jpg', 1),
(8, '/uploads/spot_hongjunshan_1.jpg', 1);

-- 旅游线路
INSERT INTO route (name, description, days, theme, cover_image, traffic_suggestion, hotel_suggestion, budget, view_count) VALUES
('遵义红色经典两日游', '深度体验遵义会议精神，追寻红军长征足迹。', 2, '经典打卡', '/uploads/route_zunyi2d.jpg', '建议自驾或乘坐高铁到遵义站，市区景点间可乘坐公交', '推荐入住遵义市区酒店，交通便利', 500.00, 8920),
('贵州红色研学五日游', '全面了解贵州红色文化，涵盖黎平、猴场、遵义等重要会议旧址。', 5, '红色研学', '/uploads/route_study5d.jpg', '建议从贵阳出发自驾，全程约800公里', '沿途各市县均有酒店，建议提前预订', 2000.00, 6540),
('四渡赤水三日游', '沿着红军四渡赤水的路线，感受那段波澜壮阔的历史。', 3, '红色研学', '/uploads/route_chishui3d.jpg', '建议自驾，部分路段为山路', '推荐土城古镇民宿，体验当地风情', 1200.00, 5670),
('贵阳红色一日游', '一天时间游览贵阳周边红色景点，适合周末出行。', 1, '经典打卡', '/uploads/route_guiyang1d.jpg', '贵阳市区出发，建议自驾', '无需住宿', 200.00, 4320),
('黔东南红色文化深度游', '探访黎平会议旧址及周边少数民族文化村寨。', 4, '小众探秘', '/uploads/route_qdndeep.jpg', '建议从贵阳或凯里出发自驾', '推荐体验当地侗族民宿', 1500.00, 3210);

-- 线路-景点关联
INSERT INTO route_spot (route_id, spot_id, day_number, sort_order, description) VALUES
(1, 1, 1, 1, '上午参观遵义会议会址'),
(1, 8, 1, 2, '下午瞻仰红军山烈士陵园'),
(1, 4, 2, 1, '第二天游览娄山关战斗遗址'),
(2, 5, 1, 1, '第一天：黎平会议会址'),
(2, 6, 2, 1, '第二天：猴场会议会址'),
(2, 1, 3, 1, '第三天：遵义会议会址'),
(2, 4, 4, 1, '第四天：娄山关'),
(2, 3, 5, 1, '第五天：四渡赤水纪念馆'),
(3, 3, 1, 1, '第一天：四渡赤水纪念馆'),
(4, 2, 1, 1, '上午：息烽集中营'),
(5, 5, 1, 1, '第一天：黎平会议会址');

-- 打卡集章示例数据（zhangsan 已集满「革命遗址」主题，可演示纪念册导出；「纪念馆」主题演示"还差1个"）
INSERT INTO spot_stamp (user_id, spot_id, theme, visit_time) VALUES
(2, 1, '革命遗址', '2026-09-10 09:30:00'),
(2, 5, '革命遗址', '2026-09-11 14:00:00'),
(2, 6, '革命遗址', '2026-09-12 10:15:00'),
(2, 2, '纪念馆', '2026-09-13 15:40:00'),
(3, 1, '革命遗址', '2026-09-15 11:20:00');

-- 红色文化分类
INSERT INTO culture_category (name, parent_id, sort_order) VALUES
('红色故事', 0, 1),
('历史事件', 0, 2),
('革命人物', 0, 3),
('红色诗词', 0, 4),
('文献资料', 0, 5),
('遵义会议相关', 2, 1),
('四渡赤水相关', 2, 2),
('长征故事', 1, 1);

-- 红色文化内容
INSERT INTO culture_content (title, content, category_id, cover_image, author, view_count) VALUES
('遵义会议——伟大的转折', '1935年1月15日至17日，中共中央政治局在遵义召开扩大会议。会议集中解决了当时具有决定意义的军事问题和组织问题。会议增选毛泽东为中央政治局常委，取消了博古、李德的最高军事指挥权。遵义会议是中国共产党历史上一个生死攸关的转折点，挽救了党、挽救了红军、挽救了中国革命。', 6, '/uploads/culture_zunyi.jpg', '编辑部', 5670),
('四渡赤水出奇兵', '四渡赤水战役是遵义会议之后，中央红军在长征途中，处于国民党几十万重兵围追堵截的艰险条件下，进行的一次决定性运动战战役。红军在毛泽东的指挥下，灵活机动地在赤水河上四次往返渡河，纵横驰骋于川黔滇边境广大地区，成功摆脱了敌人的围追堵截。', 7, '/uploads/culture_chishui.jpg', '编辑部', 4320),
('毛泽东与贵州', '毛泽东与贵州有着深厚的历史渊源。长征期间，红军在贵州活动时间最长、活动范围最广。遵义会议确立了毛泽东的领导地位，四渡赤水是毛泽东军事生涯中的得意之作。毛泽东曾多次提到贵州对中国革命的重要贡献。', 3, '/uploads/culture_mao.jpg', '编辑部', 3890),
('忆秦娥·娄山关', '西风烈，长空雁叫霜晨月。霜晨月，马蹄声碎，喇叭声咽。雄关漫道真如铁，而今迈步从头越。从头越，苍山如海，残阳如血。——毛泽东，1935年2月', 4, '/uploads/culture_poem.jpg', '毛泽东', 6780),
('张露萍的故事', '张露萍，1921年出生于四川崇庆。1938年加入中国共产党，后被派往重庆从事地下工作。1939年被捕后关押在息烽集中营。在狱中，她坚持斗争，传递情报。1945年7月14日，张露萍与6位战友一起英勇就义，年仅24岁。', 8, '/uploads/culture_zhangluping.jpg', '编辑部', 2340),
('长征中的贵州记忆', '红军长征在贵州历时4个多月，足迹遍及贵州60多个县。在贵州期间，红军不仅进行了遵义会议、黎平会议、猴场会议等重要会议，还进行了强渡乌江、四渡赤水等著名战役，对中国革命产生了深远影响。', 2, '/uploads/culture_changzheng.jpg', '编辑部', 4560);

-- 酒店数据
INSERT INTO hotel (name, description, location, cover_image, price, has_breakfast, has_room_service, phone, status, rating, longitude, latitude) VALUES
('遵义红色记忆大酒店', '位于遵义会议会址附近，是集住宿、餐饮为一体的主题酒店。酒店以红色文化为主题装饰，让您在住宿中感受革命历史。', '遵义市红花岗区子尹路88号', '/uploads/hotel_zunyi1.jpg', 328.00, 1, 1, '0851-28881234', 1, 4.5, 106.7130, 27.7250),
('息烽温泉度假酒店', '毗邻息烽集中营纪念馆，拥有天然温泉资源。是参观红色景点后放松身心的理想选择。', '贵阳市息烽县温泉镇', '/uploads/hotel_xifeng1.jpg', 458.00, 1, 1, '0851-87551234', 1, 4.7, 106.7400, 27.0950),
('土城红军客栈', '位于四渡赤水纪念馆旁，古色古香的民宿风格，感受土城古镇的魅力。', '遵义市习水县土城镇', '/uploads/hotel_tucheng1.jpg', 198.00, 1, 0, '0851-22661234', 1, 4.3, 105.9920, 28.4570),
('安顺若飞大酒店', '以王若飞先生命名，交通便利，设施齐全。距离王若飞故居步行仅10分钟。', '安顺市西秀区中华路', '/uploads/hotel_anshun1.jpg', 268.00, 1, 1, '0851-33221234', 1, 4.4, 105.9480, 26.2460),
('黎平侗乡民宿', '体验正宗侗族文化，木质吊脚楼建筑，可品尝侗族特色美食。', '黔东南州黎平县翘街', '/uploads/hotel_liping1.jpg', 168.00, 1, 0, '0855-66771234', 1, 4.6, 109.1370, 26.2315);

-- 美食门店
INSERT INTO food_store (name, location, category, hygiene_level, phone, cover_image, longitude, latitude) VALUES
('遵义老字号羊肉粉', '遵义市红花岗区中华路', '米粉面食', 'A级', '0851-28889999', '/uploads/store_yangroupen.jpg', 106.7140, 27.7260),
('贵阳花溪牛肉粉总店', '贵阳市花溪区花溪大道', '米粉面食', 'A级', '0851-83661234', '/uploads/store_niuroupen.jpg', 106.6700, 26.4100),
('安顺屯堡菜馆', '安顺市西秀区中华路', '民族菜', 'B级', '0851-33225678', '/uploads/store_tunpu.jpg', 105.9470, 26.2450),
('黎平侗家酸汤鱼', '黔东南州黎平县翘街', '酸汤系列', 'A级', '0855-66778888', '/uploads/store_suantangyu.jpg', 109.1365, 26.2310),
('土城古镇特色小吃', '遵义市习水县土城镇', '小吃', 'B级', '0851-22669999', '/uploads/store_tuchengxiaochi.jpg', 105.9915, 28.4565);

-- 美食数据
INSERT INTO food (name, description, category, price, cover_image, store_id) VALUES
('遵义羊肉粉', '遵义羊肉粉是贵州三大名粉之一，以鲜羊肉熬汤、羊肉切片，配以米粉，鲜香可口。', '米粉面食', 15.00, '/uploads/food_yangroupen.jpg', 1),
('花溪牛肉粉', '贵阳花溪牛肉粉以精选黄牛肉慢炖，汤底醇厚，米粉爽滑，是贵阳的标志性美食。', '米粉面食', 18.00, '/uploads/food_niuroupen.jpg', 2),
('酸汤鱼', '苗族传统名菜，以凯里红酸汤为底料，鱼肉鲜嫩，酸辣开胃，是贵州最具代表性的美食之一。', '酸汤系列', 68.00, '/uploads/food_suantangyu.jpg', 4),
('丝娃娃', '贵阳著名小吃，用薄饼包裹各种蔬菜丝，蘸以特制辣椒水，清爽可口。', '小吃', 25.00, '/uploads/food_siwawa.jpg', 5),
('屯堡辣子鸡', '安顺屯堡传统菜肴，选用本地土鸡，配以糍粑辣椒爆炒，麻辣鲜香。', '辣子系列', 58.00, '/uploads/food_laziji.jpg', 3),
('豆腐圆子', '贵阳名小吃，以豆腐为主料制成圆子油炸，外酥里嫩，蘸辣椒面食用。', '小吃', 10.00, '/uploads/food_doufuyuanzi.jpg', 5),
('肠旺面', '贵阳特色面食，以猪大肠、猪血旺、脆哨为主要配料，面条爽滑有嚼劲。', '米粉面食', 16.00, '/uploads/food_changwangmian.jpg', 2);

-- FAQ智能客服
INSERT INTO faq (question, answer, sort_order) VALUES
('景点门票', '贵州大部分红色旅游景点为免费参观，部分景点需要预约。详情请查看各景点详情页面中的门票价格信息。', 1),
('开放时间', '大多数红色景点的开放时间为上午8:30到下午17:00，部分露天景点全天开放。建议出行前查看具体景点的开放时间信息。', 2),
('交通', '贵州各红色景点可通过高铁、长途汽车或自驾前往。遵义、贵阳等主要城市交通便利，偏远景点建议自驾出行。', 3),
('住宿', '各景点周边均有酒店和民宿可供选择。建议旺季提前预订，可在本系统的酒店模块中查看和预订。', 4),
('美食推荐', '贵州特色美食丰富，推荐品尝遵义羊肉粉、花溪牛肉粉、酸汤鱼、丝娃娃等。更多美食信息可在美食模块中查看。', 5),
('预约', '部分热门景点需要提前预约，请在景点详情页查看是否需要预约，并提前做好安排。', 6),
('天气', '贵州气候温和湿润，建议出行时携带雨具。夏季较为凉爽，是避暑旅游的好去处。冬季气温较低，注意保暖。', 7),
('客服', '如需人工帮助，请拨打客服热线：0851-12345，工作时间为每天9:00-18:00。您也可以在留言板留言，我们会尽快回复。', 8);

-- 消息示例
INSERT INTO message (user_id, title, content, is_read) VALUES
(2, '欢迎注册', '欢迎注册贵州红色文化旅游信息管理系统！祝您旅途愉快。', 0),
(3, '欢迎注册', '欢迎注册贵州红色文化旅游信息管理系统！祝您旅途愉快。', 0);

-- =============================================
-- 多语言内容：EN / JA 译文（景点）
-- =============================================
UPDATE scenic_spot SET
  name_en = 'Zunyi Conference Site',
  description_en = 'The Zunyi Conference Site is located at No. 96 Ziyin Road, Honghuagang District, Zunyi City. It is a key national cultural heritage site and a classic destination for red tourism in China.',
  name_ja = '遵義会議旧址',
  description_ja = '遵義会議旧址は遵義市紅花崗区子尹路96号にあり、国家重点文物保護単位および全国紅色旅游経典景区に指定されています。'
WHERE id = 1;

UPDATE scenic_spot SET
  name_en = 'Xifeng Concentration Camp Revolutionary History Museum',
  description_en = 'The Xifeng Concentration Camp was the largest and highest-level secret prison established by the Kuomintang Military Statistics Bureau during the War of Resistance Against Japan.',
  name_ja = '息鋒集中営革命歴史記念館',
  description_ja = '息鋒集中営は抗日戦争期に国民党軍統が設立した、規模最大・等級最高の秘密監獄です。'
WHERE id = 2;

UPDATE scenic_spot SET
  name_en = 'Four Crossings of Chishui Memorial Hall',
  description_en = 'Located in Tucheng Town, Xishui County, it comprehensively showcases the glorious journey of the Red Army crossing the Chishui River four times.',
  name_ja = '四渡赤水記念館',
  description_ja = '習水県土城鎮に位置し、紅軍が赤水河を四度渡った光輝ある歴程を全面的に展示しています。'
WHERE id = 3;

UPDATE scenic_spot SET
  name_en = 'Loushan Pass Battle Site',
  description_en = 'Loushan Pass was a key strategic gateway on the Sichuan-Guizhou transportation route. The Red Army captured the pass twice during the Long March.',
  name_ja = '楼山関戦闘遺址',
  description_ja = '楼山関は川貴交通幹線上の重要な関所であり、紅軍は長征中に二度この関を攻略しました。'
WHERE id = 4;

UPDATE scenic_spot SET
  name_en = 'Liping Conference Site',
  description_en = 'The Liping Conference was an important meeting held during the Red Army Long March, laying the groundwork for the Zunyi Conference.',
  name_ja = '黎平会議旧址',
  description_ja = '黎平会議は紅軍長征中の重要な会議であり、遵義会議の開催に向けた基盤を築きました。',
  ticket_reservation_en = 'Free admission. Advance reservation required via official WeChat public account. Enter with ID card. Closed on Mondays (except statutory holidays).',
  ticket_reservation_ja = '無料観覧。公式WeChat公式アカウントで事前予約が必要です。身分証明書で入館。月曜日休館（祝日除く）。',
  suggested_duration_en = 'Recommended: 2-3 hours',
  suggested_duration_ja = '推奨滞在時間：2～3時間',
  items_to_bring_en = 'ID card, mask, comfortable walking shoes, sun hat, camera, power bank',
  items_to_bring_ja = '身分証明書、マスク、快適なウォーキングシューズ、帽子、カメラ、モバイルバッテリー'
WHERE id = 1;

UPDATE scenic_spot SET
  ticket_reservation_en = 'Free admission. Collect ticket at entrance with ID card. Recommended to call 1 day in advance to confirm opening hours.',
  ticket_reservation_ja = '無料観覧。入り口で身分証明書と引き換えにチケットを受け取り。開館状況を事前に電話確認することを推奨。',
  suggested_duration_en = 'Recommended: 1.5-2 hours',
  suggested_duration_ja = '推奨滞在時間：1.5～2時間',
  items_to_bring_en = 'ID card, drinking water, umbrella, comfortable walking shoes, tissues',
  items_to_bring_ja = '身分証明書、飲料水、傘、快適なウォーキングシューズ、ティッシュ'
WHERE id = 2;

UPDATE scenic_spot SET
  ticket_reservation_en = 'Free admission. Register with ID card at entrance. Advance reservation recommended during peak season.',
  ticket_reservation_ja = '無料観覧。入り口で身分証明書を提示し登録。繁忙期は事前予約を推奨。',
  suggested_duration_en = 'Recommended: 2-2.5 hours',
  suggested_duration_ja = '推奨滞在時間：2～2.5時間',
  items_to_bring_en = 'ID card, motion sickness medicine, bottled water, sun protection, comfortable sneakers',
  items_to_bring_ja = '身分証明書、酔い止め薬、ペットボトルの水、日焼け止め、快適なスニーカー'
WHERE id = 3;

UPDATE scenic_spot SET
  ticket_reservation_en = 'Outdoor site, no reservation needed. Free admission. May be temporarily closed during severe weather, please check weather forecast.',
  ticket_reservation_ja = '屋外遺跡、予約不要。無料開放。悪天候時は臨時閉鎖の可能性あり。天気予報をご確認ください。',
  suggested_duration_en = 'Recommended: 1.5-2 hours',
  suggested_duration_ja = '推奨滞在時間：1.5～2時間',
  items_to_bring_en = 'ID card, warm jacket (mountain area windy), non-slip hiking shoes, mobile phone, umbrella',
  items_to_bring_ja = '身分証明書、保温ジャケット（山間部は風が強い）、滑り止め付き登山靴、携帯電話、傘'
WHERE id = 4;

UPDATE scenic_spot SET
  ticket_reservation_en = 'Free admission. Collect ticket at entrance with ID card. Group tours need to reserve guide service 3 days in advance.',
  ticket_reservation_ja = '無料観覧。入り口で身分証明書と引き換えにチケットを受け取り。団体観覧は3日前にガイドサービスを予約すること。',
  suggested_duration_en = 'Recommended: 1.5-2 hours',
  suggested_duration_ja = '推奨滞在時間：1.5～2時間',
  items_to_bring_en = 'ID card, mosquito repellent, sun protection, comfortable walking shoes, camera',
  items_to_bring_ja = '身分証明書、虫除けスプレー、日焼け止め、快適なウォーキングシューズ、カメラ'
WHERE id = 5;

UPDATE scenic_spot SET
  ticket_reservation_en = 'Free admission. Register with ID card at entrance. Closed on Mondays (postponed during holidays).',
  ticket_reservation_ja = '無料観覧。入り口で身分証明書を提示し登録。月曜日休館（祝日は顺延）。',
  suggested_duration_en = 'Recommended: 1-1.5 hours',
  suggested_duration_ja = '推奨滞在時間：1～1.5時間',
  items_to_bring_en = 'ID card, bottled water, tissues, power bank, comfortable walking shoes',
  items_to_bring_ja = '身分証明書、ペットボトルの水、ティッシュ、モバイルバッテリー、快適なウォーキングシューズ'
WHERE id = 6;

UPDATE scenic_spot SET
  ticket_reservation_en = 'Free admission. Enter with ID card. Guide service available on-site reservation.',
  ticket_reservation_ja = '無料開放。身分証明書で入館。ガイドサービスは現地予約可。',
  suggested_duration_en = 'Recommended: 1-1.5 hours',
  suggested_duration_ja = '推奨滞在時間：1～1.5時間',
  items_to_bring_en = 'ID card, mask, parasol, mobile phone, notebook',
  items_to_bring_ja = '身分証明書、マスク、日傘、携帯電話、ノート'
WHERE id = 7;

UPDATE scenic_spot SET
  ticket_reservation_en = 'Open cemetery, no reservation needed. Please maintain solemnity and visit respectfully.',
  ticket_reservation_ja = '開放式霊園、予約不要。厳粛な雰囲気を保ち、敬意を持って参拝をお願いします。',
  suggested_duration_en = 'Recommended: 1-1.5 hours',
  suggested_duration_ja = '推奨滞在時間：1～1.5時間',
  items_to_bring_en = 'ID card, water, tissues, comfortable walking shoes, sun hat',
  items_to_bring_ja = '身分証明書、水、ティッシュ、快適なウォーキングシューズ、帽子'
WHERE id = 8;

-- =============================================
-- 多语言内容：EN / JA 译文（线路）
-- =============================================
UPDATE route SET
  name_en = 'Zunyi Red Classic 2-Day Tour',
  description_en = 'An in-depth experience of the Zunyi Conference spirit, following in the footsteps of the Red Army on the Long March.',
  name_ja = '遵義紅色クラシック2日間ツアー',
  description_ja = '遵義会議の精神を深く体験し、紅軍長征の足跡をたどる旅。'
WHERE id = 1;

UPDATE route SET
  name_en = 'Guizhou Red Study Tour 5 Days',
  description_en = 'A comprehensive exploration of Guizhou red culture, covering key conference sites including Liping, Houchang, and Zunyi.',
  name_ja = '貴州紅色研学5日間ツアー',
  description_ja = '黎平・猴場・遵義などの重要な会議旧址を巡り、貴州の紅色文化を総合的に学びます。'
WHERE id = 2;

UPDATE route SET
  name_en = 'Four Crossings of Chishui 3-Day Tour',
  description_en = 'Follow the route of the Red Army\'s four crossings of the Chishui River and feel the magnificent history of that era.',
  name_ja = '四渡赤水3日間ツアー',
  description_ja = '紅軍が赤水河を四度渡ったルートを辿り、その波乱万丈の歴史を体感します。'
WHERE id = 3;

-- =============================================
-- 多语言内容：EN / JA 译文（红色文化）
-- =============================================
UPDATE culture_content SET
  title_en = 'The Zunyi Conference — A Great Turning Point',
  content_en = 'From January 15 to 17, 1935, the Politburo of the Central Committee of the Communist Party of China held an enlarged meeting in Zunyi. The meeting resolved the decisive military and organizational issues of the time. Mao Zedong was elected to the Standing Committee of the Politburo, and Bo Gu and Li De were stripped of their supreme military command. The Zunyi Conference was a pivotal turning point in the history of the Communist Party of China, saving the Party, the Red Army, and the Chinese Revolution.',
  title_ja = '遵義会議——偉大なる転換点',
  content_ja = '1935年1月15日から17日にかけて、中国共産党中央政治局は遵義で拡大会議を開催しました。会議では当時の決定的な軍事問題と組織問題を集中的に解決しました。毛沢東が中央政治局常務委員に選出され、博古と李徳の最高軍事指揮権が取り消されました。遵義会議は中国共産党の歴史における生死をわける転換点であり、党・紅軍・中国革命を救いました。'
WHERE id = 1;

UPDATE culture_content SET
  title_en = 'Four Crossings of Chishui — A Brilliant Military Feat',
  content_en = 'The Battle of the Four Crossings of Chishui was a decisive maneuver warfare campaign conducted by the Central Red Army after the Zunyi Conference, under the encirclement of hundreds of thousands of Kuomintang troops. Under Mao Zedong\'s command, the Red Army flexibly maneuvered across the Chishui River four times in the border area of Sichuan, Guizhou, and Yunnan, successfully breaking through the enemy\'s encirclement.',
  title_ja = '四渡赤水——奇兵出撃',
  content_ja = '四渡赤水戦役は遵義会議後、中央紅軍が国民党数十万の重兵に包囲された険しい状況の中で展開した決定的な運動戦戦役です。毛沢東の指揮のもと、紅軍は川貴滇境界広大地域で赤水河を四度往復し、敵の包囲追撃を見事に打ち破りました。'
WHERE id = 2;

-- ============================================================
-- 示例用户反馈
-- ============================================================
INSERT IGNORE INTO feedback (user_id, contact, category, title, content, status)
SELECT id, phone, 'SUGGESTION', '希望增加景点开放时间实时推送功能',
  '目前景点开放时间是静态信息。建议在临时关闭或延长开放时，能主动推送提醒，提升游客体验。', 'PENDING'
FROM sys_user WHERE username = 'zhangsan' LIMIT 1;

INSERT IGNORE INTO feedback (user_id, contact, category, title, content, status, reply, reply_time)
SELECT id, phone, 'BUG', '日文界面下景点介绍显示中文',
  '切换日文模式后，遵义会议会址的景点介绍仍显示中文，未显示日文翻译。', 'RESOLVED',
  '感谢反馈！我们已修复该问题，请清除浏览器缓存后重试。', NOW()
FROM sys_user WHERE username = 'lisi' LIMIT 1;

-- 角色数据
INSERT IGNORE INTO sys_role (code, name, description) VALUES
('USER', '游客', '普通注册用户，可浏览景点、预订、收藏、评论'),
('ADMIN', '管理员', '系统管理员，拥有全部管理权限'),
('STAFF', '工作人员', '仅可操作所属景点');

-- 角色菜单权限（默认配置）
INSERT IGNORE INTO sys_role_menu (role_code, menu_key, menu_name, enabled) VALUES
('ADMIN', 'dashboard', '仪表盘', 1),
('ADMIN', 'user_manage', '用户管理', 1),
('ADMIN', 'spot_manage', '景点管理', 1),
('ADMIN', 'route_manage', '线路管理', 1),
('ADMIN', 'culture_manage', '文化管理', 1),
('ADMIN', 'hotel_manage', '酒店管理', 1),
('ADMIN', 'food_manage', '美食管理', 1),
('ADMIN', 'comment_manage', '留言管理', 1),
('ADMIN', 'order_manage', '订单管理', 1),
('ADMIN', 'faq_manage', 'FAQ管理', 1),
('ADMIN', 'feedback_manage', '反馈管理', 1),
('ADMIN', 'route_review', '线路审核', 1),
('ADMIN', 'spot_review', '景点审核', 1),
('ADMIN', 'role_manage', '权限配置', 1),
('ADMIN', 'customer_service', '人工客服', 1),
('ADMIN', 'user_export', '用户导出', 1),
('STAFF', 'dashboard', '仪表盘', 1),
('STAFF', 'spot_manage', '景点管理', 1),
('USER', 'view_spot', '浏览景点', 1),
('USER', 'book_order', '预订下单', 1),
('USER', 'comment', '评论留言', 1),
('USER', 'favorite', '收藏点赞', 1),
('USER', 'custom_route', '自定义线路', 1),
('USER', 'feedback', '问题反馈', 1),
('USER', 'customer_service', '人工客服', 1);
