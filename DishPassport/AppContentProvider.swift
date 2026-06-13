import Foundation

protocol ContentProviding {
    func loadContent(screenshotMode: ScreenshotMode) -> AppContent
}

struct AppContentProvider: ContentProviding {
    func loadContent(screenshotMode: ScreenshotMode) -> AppContent {
        #if DEBUG
        if screenshotMode == .demoData {
            return DemoScreenshotContent.content
        }
        #endif
        return ProductionContent.content
    }
}

enum ProductionContent {
    static let content = AppContent(
        dishes: dishes,
        cuisines: cuisines,
        phrases: phrases,
        cultureCards: cultureCards
    )

    static let dishes: [Dish] = [
        Dish(
            id: "mapo-tofu",
            englishName: "Mapo Tofu",
            chineseName: "麻婆豆腐",
            pinyin: "ma po dou fu",
            japaneseName: "麻婆豆腐",
            cuisineID: .sichuan,
            heatLevel: .hot,
            flavorKeys: ["numbing", "spicy", "savory"],
            ingredients: ["tofu", "chili bean paste", "Sichuan peppercorn", "minced pork"],
            orderingPhrase: "Mapo tofu, less spicy please.",
            cultureNote: "The signature sensation is ma, the gentle numbing tingle from Sichuan peppercorns, not only heat.",
            bestWith: "steamed rice",
            searchTokens: ["mapo", "ma po", "tofu", "sichuan", "麻婆", "豆腐", "spicy"]
        ),
        Dish(
            id: "xiaolongbao",
            englishName: "Soup Dumplings",
            chineseName: "小笼包",
            pinyin: "xiao long bao",
            japaneseName: "小籠包",
            cuisineID: .jiangnan,
            heatLevel: .mild,
            flavorKeys: ["brothy", "delicate", "savory"],
            ingredients: ["pork", "gelatinized broth", "wheat wrapper", "ginger"],
            orderingPhrase: "Could we have soup dumplings with vinegar?",
            cultureNote: "Bite a small opening first, sip the broth, then add a little vinegar and ginger.",
            bestWith: "black vinegar and ginger",
            searchTokens: ["xiaolongbao", "soup dumplings", "dumpling", "小笼包", "小籠包", "jiangnan"]
        ),
        Dish(
            id: "char-siu",
            englishName: "Char Siu",
            chineseName: "叉烧",
            pinyin: "cha shao",
            japaneseName: "チャーシュー",
            cuisineID: .cantonese,
            heatLevel: .mild,
            flavorKeys: ["sweet", "roasted", "savory"],
            ingredients: ["pork", "honey", "soy sauce", "five-spice"],
            orderingPhrase: "Char siu over rice, please.",
            cultureNote: "Cantonese barbecue shops display roasted meats in the window so diners can choose cuts visually.",
            bestWith: "steamed rice or noodles",
            searchTokens: ["char siu", "bbq pork", "叉烧", "叉燒", "cantonese", "pork"]
        ),
        Dish(
            id: "dan-dan-noodles",
            englishName: "Dan Dan Noodles",
            chineseName: "担担面",
            pinyin: "dan dan mian",
            japaneseName: "担々麺",
            cuisineID: .sichuan,
            heatLevel: .medium,
            flavorKeys: ["nutty", "spicy", "aromatic"],
            ingredients: ["wheat noodles", "chili oil", "sesame paste", "minced pork"],
            orderingPhrase: "Dan dan noodles, medium spicy.",
            cultureNote: "The name refers to shoulder poles once used by street vendors carrying noodles and sauce.",
            bestWith: "cucumber salad",
            searchTokens: ["dan dan", "dandan", "noodles", "担担面", "擔擔麵", "sichuan"]
        ),
        Dish(
            id: "kung-pao-chicken",
            englishName: "Kung Pao Chicken",
            chineseName: "宫保鸡丁",
            pinyin: "gong bao ji ding",
            japaneseName: "宮保鶏丁",
            cuisineID: .sichuan,
            heatLevel: .medium,
            flavorKeys: ["sweet-sour", "nutty", "lightly spicy"],
            ingredients: ["chicken", "peanuts", "dried chili", "scallion"],
            orderingPhrase: "Kung pao chicken with rice, please.",
            cultureNote: "The Chinese version is usually drier, brighter, and more balanced than many takeout versions.",
            bestWith: "rice and greens",
            searchTokens: ["kung pao", "gong bao", "chicken", "宫保", "雞丁", "peanuts"]
        ),
        Dish(
            id: "hot-pot",
            englishName: "Spicy Hot Pot",
            chineseName: "麻辣火锅",
            pinyin: "ma la huo guo",
            japaneseName: "麻辣火鍋",
            cuisineID: .sichuan,
            heatLevel: .veryHot,
            flavorKeys: ["communal", "numbing", "rich"],
            ingredients: ["broth", "beef", "vegetables", "tofu skin"],
            orderingPhrase: "Could we choose a split pot?",
            cultureNote: "Hot pot is social food: order several ingredients, cook them together, and mix your own dipping sauce.",
            bestWith: "sesame oil dip",
            searchTokens: ["hot pot", "huo guo", "火锅", "火鍋", "mala", "spicy"]
        ),
        Dish(
            id: "peking-duck",
            englishName: "Peking Duck",
            chineseName: "北京烤鸭",
            pinyin: "bei jing kao ya",
            japaneseName: "北京ダック",
            cuisineID: .northern,
            heatLevel: .mild,
            flavorKeys: ["crisp", "rich", "ceremonial"],
            ingredients: ["duck", "pancakes", "scallion", "sweet bean sauce"],
            orderingPhrase: "One Peking duck set, please.",
            cultureNote: "The pleasure is contrast: crisp skin, soft pancake, sharp scallion, and sweet bean sauce.",
            bestWith: "thin pancakes",
            searchTokens: ["peking duck", "beijing duck", "北京烤鸭", "北京烤鴨", "duck"]
        ),
        Dish(
            id: "hand-pulled-noodles",
            englishName: "Hand-Pulled Noodles",
            chineseName: "兰州拉面",
            pinyin: "lan zhou la mian",
            japaneseName: "蘭州拉麺",
            cuisineID: .noodles,
            heatLevel: .mild,
            flavorKeys: ["beefy", "clear broth", "springy"],
            ingredients: ["wheat noodles", "beef broth", "radish", "cilantro"],
            orderingPhrase: "Hand-pulled beef noodles, no cilantro please.",
            cultureNote: "A classic bowl balances clear broth, white radish, red chili oil, green herbs, and hand-pulled noodles.",
            bestWith: "chili oil on the side",
            searchTokens: ["hand pulled", "noodles", "lamian", "拉面", "拉麺", "beef"]
        ),
        Dish(
            id: "scallion-pancake",
            englishName: "Scallion Pancake",
            chineseName: "葱油饼",
            pinyin: "cong you bing",
            japaneseName: "葱油餅",
            cuisineID: .snacks,
            heatLevel: .mild,
            flavorKeys: ["flaky", "savory", "crispy"],
            ingredients: ["wheat dough", "scallion", "oil", "salt"],
            orderingPhrase: "One scallion pancake to share, please.",
            cultureNote: "Its flaky layers come from folding oil and scallions into dough before pan-frying.",
            bestWith: "soy-vinegar dip",
            searchTokens: ["scallion pancake", "葱油饼", "蔥油餅", "snack", "pancake"]
        ),
        Dish(
            id: "hunan-fish-head",
            englishName: "Steamed Fish Head with Chopped Chili",
            chineseName: "剁椒鱼头",
            pinyin: "duo jiao yu tou",
            japaneseName: "刻み唐辛子魚頭蒸し",
            cuisineID: .hunan,
            heatLevel: .veryHot,
            flavorKeys: ["fresh chili", "salty", "steamed"],
            ingredients: ["fish head", "chopped chili", "ginger", "scallion"],
            orderingPhrase: "Is the fish head very spicy?",
            cultureNote: "Hunan heat is often direct and fresh, built from chopped chilies rather than peppercorn numbness.",
            bestWith: "plain rice",
            searchTokens: ["hunan", "fish head", "剁椒鱼头", "剁椒魚頭", "spicy fish"]
        ),
        Dish(
            id: "har-gow",
            englishName: "Shrimp Dumplings",
            chineseName: "虾饺",
            pinyin: "xia jiao",
            japaneseName: "海老蒸し餃子",
            cuisineID: .dimSum,
            heatLevel: .mild,
            flavorKeys: ["delicate", "springy", "clean"],
            ingredients: ["shrimp", "wheat starch wrapper", "bamboo shoot", "sesame oil"],
            orderingPhrase: "Shrimp dumplings, one basket please.",
            cultureNote: "Dim sum is ordered in small plates or steamer baskets, often shared over tea.",
            bestWith: "jasmine tea",
            searchTokens: ["har gow", "shrimp dumpling", "虾饺", "蝦餃", "dim sum"]
        ),
        Dish(
            id: "tea-eggs",
            englishName: "Tea Eggs",
            chineseName: "茶叶蛋",
            pinyin: "cha ye dan",
            japaneseName: "茶葉卵",
            cuisineID: .snacks,
            heatLevel: .mild,
            flavorKeys: ["tea-scented", "soy", "warm spice"],
            ingredients: ["egg", "black tea", "soy sauce", "star anise"],
            orderingPhrase: "One tea egg, please.",
            cultureNote: "The marbled pattern forms when cracked shells let tea and soy seep into the egg.",
            bestWith: "congee or noodles",
            searchTokens: ["tea egg", "茶叶蛋", "茶葉蛋", "snack", "egg"]
        )
    ]

    static let cuisines: [Cuisine] = [
        Cuisine(id: .sichuan, englishName: "Sichuan", chineseName: "川菜", japaneseName: "四川料理", shortDescription: "Layered heat, fragrant chili oil, and the numbing sparkle of Sichuan peppercorns.", orderingTip: "Ask for mild or medium if you are new to ma la flavors.", representativeDishIDs: ["mapo-tofu", "dan-dan-noodles", "kung-pao-chicken", "hot-pot"]),
        Cuisine(id: .cantonese, englishName: "Cantonese", chineseName: "粤菜", japaneseName: "広東料理", shortDescription: "Roasted meats, fresh seafood, dim sum, and restrained sauces.", orderingTip: "Look for barbecue rice plates, steamed fish, and tea service.", representativeDishIDs: ["char-siu", "har-gow"]),
        Cuisine(id: .jiangnan, englishName: "Jiangnan", chineseName: "江南", japaneseName: "江南料理", shortDescription: "Gentle sweetness, brothy dumplings, river fish, and refined snacks.", orderingTip: "Vinegar and ginger often bring balance to rich fillings.", representativeDishIDs: ["xiaolongbao"]),
        Cuisine(id: .northern, englishName: "Northern", chineseName: "北方", japaneseName: "北方料理", shortDescription: "Wheat noodles, dumplings, buns, lamb, and imperial dishes.", orderingTip: "Share pancakes, dumplings, and roasted dishes family-style.", representativeDishIDs: ["peking-duck"]),
        Cuisine(id: .hunan, englishName: "Hunan", chineseName: "湘菜", japaneseName: "湖南料理", shortDescription: "Fresh chili heat, smoked meats, pickled vegetables, and bold aromatics.", orderingTip: "Hunan dishes can be hotter than they look; ask before ordering.", representativeDishIDs: ["hunan-fish-head"]),
        Cuisine(id: .dimSum, englishName: "Dim Sum", chineseName: "点心", japaneseName: "点心", shortDescription: "Small plates, steamer baskets, tea, and shared brunch energy.", orderingTip: "Order several baskets and share across the table.", representativeDishIDs: ["har-gow", "xiaolongbao"]),
        Cuisine(id: .noodles, englishName: "Noodles", chineseName: "面食", japaneseName: "麺料理", shortDescription: "Pulled, cut, stretched, or knife-shaved noodles across regions.", orderingTip: "Check broth, spice level, and toppings before choosing.", representativeDishIDs: ["hand-pulled-noodles", "dan-dan-noodles"]),
        Cuisine(id: .snacks, englishName: "Snacks", chineseName: "小吃", japaneseName: "軽食", shortDescription: "Street bites, pancakes, tea eggs, skewers, and quick comfort foods.", orderingTip: "Snacks are good side orders when you want to explore safely.", representativeDishIDs: ["scallion-pancake", "tea-eggs"])
    ]

    static let phrases: [Phrase] = [
        Phrase(id: "less-spicy", english: "Less spicy, please.", chinese: "请少辣一点。", pinyin: "qing shao la yi dian", japanese: "辛さ控えめでお願いします。", usage: "Use this when ordering Sichuan, Hunan, or hot pot dishes."),
        Phrase(id: "no-cilantro", english: "No cilantro, please.", chinese: "请不要香菜。", pinyin: "qing bu yao xiang cai", japanese: "パクチー抜きでお願いします。", usage: "Useful for noodle soups and cold dishes."),
        Phrase(id: "share", english: "We will share everything.", chinese: "我们一起分着吃。", pinyin: "wo men yi qi fen zhe chi", japanese: "みんなで分けて食べます。", usage: "Chinese meals are often shared family-style."),
        Phrase(id: "recommend", english: "What do you recommend?", chinese: "你推荐什么？", pinyin: "ni tui jian shen me", japanese: "おすすめは何ですか？", usage: "Ask staff for house specialties."),
        Phrase(id: "rice", english: "Could we have rice?", chinese: "可以来米饭吗？", pinyin: "ke yi lai mi fan ma", japanese: "ご飯をいただけますか？", usage: "Many saucy dishes are best with plain rice.")
    ]

    static let cultureCards: [CultureCard] = [
        CultureCard(id: "ma-la", title: "Ma La is two sensations", body: "Ma is numbing from peppercorns; la is chili heat. Sichuan dishes often balance both.", relatedDishID: "mapo-tofu"),
        CultureCard(id: "family-style", title: "Family-style sharing", body: "Many Chinese restaurant meals are designed for the table, not one entree per person.", relatedDishID: nil),
        CultureCard(id: "tea-dim-sum", title: "Tea anchors dim sum", body: "Dim sum is traditionally paired with tea, giving the meal its relaxed brunch rhythm.", relatedDishID: "har-gow")
    ]
}

#if DEBUG
enum DemoScreenshotContent {
    static var content: AppContent {
        ProductionContent.content
    }
}
#endif
