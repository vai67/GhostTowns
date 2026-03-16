import SwiftUI

struct Nation: Identifiable, Hashable {
    let id: Int
    let name: String
    let also: String
    let region: String
    let colorHex: String
    let population: String
    let year: Int
    let presentDay: String
    let displaced: String
    let quote: String
    let land: String
    let removal: String
    let language: String
    let treaty: String

    var color: Color { Color(hex: colorHex) ?? T.rust }
    static func == (a: Nation, b: Nation) -> Bool { a.id == b.id }
    func hash(into h: inout Hasher) { h.combine(id) }

    static let all: [Nation] = [
        Nation(id:1, name:"Lenape", also:"The Original People", region:"Northeast", colorHex:"#8B4513",
               population:"16,000", year:1626,
               presentDay:"New York, New Jersey, Pennsylvania, Delaware",
               displaced:"Oklahoma, Wisconsin, Ontario",
               quote:"We have not given up our right to this land. We have never ceded it.",
               land:"They called it Lenapehoking. Every inch of what is now Manhattan, New Jersey, Delaware and eastern Pennsylvania was home. They fished rivers the Dutch would later rename, farmed valleys that would become cities.",
               removal:"In 1626 the Dutch recorded a purchase of Manhattan for sixty guilders worth of trade goods. The Lenape had no framework for selling land. To them, the exchange meant shared use. That misunderstanding, deliberate or not, was repeated hundreds of times across the continent.",
               language:"Lenape, also called Unami, has fewer than ten fluent native speakers alive today. The Lenape Language Project is documenting what remains.",
               treaty:"Treaty of Shackamaxon, 1682. One of the few early treaties considered fair by both sides. It did not hold."),
        Nation(id:2, name:"Cherokee", also:"Aniyvwiya", region:"Southeast", colorHex:"#6B3A2A",
               population:"392,000", year:1838,
               presentDay:"Georgia, Tennessee, North Carolina, Alabama",
               displaced:"Oklahoma",
               quote:"The land of the Indian is our land. We will not leave it.",
               land:"The Great Smoky Mountains. Red clay hills of Georgia. Land continuously inhabited for more than ten thousand years. The Cherokee established a constitutional government, a written language and a free press, and were removed anyway.",
               removal:"In the winter of 1838 the U.S. Army marched 16,000 Cherokee from their homeland at gunpoint. Soldiers burned houses behind them. Four thousand people died before reaching Oklahoma. The Cherokee call it Nunna daul Tsuny.",
               language:"Cherokee script was created by Sequoyah in 1821, one of the few writing systems invented by a single person. About 2,000 people speak it today. Immersion schools in Oklahoma and North Carolina are working to extend that number.",
               treaty:"Treaty of New Echota, 1835. Signed by a small unauthorized faction. The majority of Cherokee never agreed to it."),
        Nation(id:3, name:"Lakota Sioux", also:"Ochethi Sakowin", region:"Great Plains", colorHex:"#5C4A1E",
               population:"170,000", year:1877,
               presentDay:"South Dakota, North Dakota, Nebraska, Wyoming, Montana",
               displaced:"Reservations across the Dakotas",
               quote:"The Black Hills are not for sale. They never were.",
               land:"Paha Sapa. The Black Hills. The Fort Laramie Treaty of 1868 guaranteed it to the Lakota as long as rivers run and grass grows. That guarantee lasted six years, until Custer found gold in 1874.",
               removal:"In 1980 the Supreme Court ruled the Black Hills had been illegally taken and awarded $106 million. The Lakota refused. That sum has sat untouched for over forty years, growing past two billion dollars. They want the land.",
               language:"Lakhotiyapi is being taught in reservation schools. Around 2,000 fluent speakers remain, most of them elders.",
               treaty:"Fort Laramie Treaty, 1868. Broken six years later when gold was discovered on the land it protected."),
        Nation(id:4, name:"Muscogee", also:"Creek Nation", region:"Southeast", colorHex:"#7A4419",
               population:"100,000", year:1836,
               presentDay:"Alabama, Georgia, Florida",
               displaced:"Oklahoma",
               quote:"We did not sell our land. We were removed from it.",
               land:"Rich bottomlands along Alabama and Georgia rivers. The Muscogee Confederacy, a structured alliance of dozens of towns, was one of the most sophisticated political systems in pre-contact North America.",
               removal:"The removal of 1836 killed an estimated 3,500 people through starvation, disease and violence. Those who resisted were marched in chains. Entire towns were burned.",
               language:"Mvskoke is actively taught in Muscogee Nation immersion schools and remains one of the more vital Indigenous languages in the Southeast.",
               treaty:"Treaty of Cusseta, 1832. Promised individual land grants to Muscogee citizens. Most were taken through fraud within years."),
        Nation(id:5, name:"Haudenosaunee", also:"The Iroquois Confederacy", region:"Northeast", colorHex:"#4A3728",
               population:"125,000", year:1784,
               presentDay:"New York, Pennsylvania, Ohio, Ontario",
               displaced:"Reservations in New York, Ontario, Quebec, Wisconsin, Oklahoma",
               quote:"We are the people of the longhouse. We have always been here.",
               land:"The Finger Lakes. The St. Lawrence valley. A confederacy of six nations bound by the Great Law of Peace, a constitution predating the United States by centuries that some historians believe influenced the American framers.",
               removal:"In 1783 Britain ceded Haudenosaunee territory to the United States. No one consulted the people who lived there. Over two centuries of treaties, their land shrank by 99 percent.",
               language:"Six languages: Mohawk, Oneida, Onondaga, Cayuga, Seneca, Tuscarora. All are endangered. Mohawk has the most active revitalization effort.",
               treaty:"Treaty of Paris, 1783. Britain transferred Haudenosaunee land as if it were theirs to give."),
        Nation(id:6, name:"Dine", also:"Navajo Nation", region:"Southwest", colorHex:"#8B5E3C",
               population:"400,000", year:1864,
               presentDay:"Arizona, New Mexico, Utah",
               displaced:"Bosque Redondo, New Mexico",
               quote:"The land is our mother. You do not sell your mother.",
               land:"Dinetah, bounded by four sacred mountains. The Navajo Nation is the largest reservation in the United States and still a fraction of the original territory.",
               removal:"The Long Walk of 1864: eight to ten thousand Dine were forced to march three hundred miles to Bosque Redondo. Around two thousand died. When they returned in 1868 they found their homes burned and their livestock gone.",
               language:"Dine Bizaad is spoken by roughly 170,000 people. Navajo Code Talkers used it as an unbreakable military cipher in World War II.",
               treaty:"Treaty of Bosque Redondo, 1868. Allowed partial return to a fraction of ancestral land."),
    ]

    static func match(slug: String) -> Nation? {
        let s = slug.lowercased()
        let lookup: [Int: [String]] = [
            1: ["lenape","delaware","munsee"],
            2: ["cherokee","tsalagi"],
            3: ["lakota","sioux","oceti","oglala","dakota"],
            4: ["muscogee","creek","mvskoke"],
            5: ["haudenosaunee","iroquois","mohawk","oneida","onondaga","cayuga","seneca"],
            6: ["dine","navajo"],
        ]
        return all.first { lookup[$0.id]?.contains(where: { s.contains($0) }) == true }
    }
}

struct BlockEvent {
    let year: Int
    let label: String

    static let all: [BlockEvent?] = [
        nil,
        BlockEvent(year:1783, label:"Treaty of Paris, Britain cedes tribal land without consent"),
        BlockEvent(year:1803, label:"Louisiana Purchase, France sells land it did not own"),
        BlockEvent(year:1830, label:"Indian Removal Act, all eastern tribes forced west"),
        BlockEvent(year:1838, label:"Trail of Tears, 16,000 Cherokee marched at gunpoint"),
        BlockEvent(year:1848, label:"Mexican Cession, southwest territories absorbed"),
        BlockEvent(year:1851, label:"Fort Laramie Treaty, Great Plains territories reduced"),
        BlockEvent(year:1864, label:"Sand Creek and the Long Walk, military campaigns seize land"),
        BlockEvent(year:1874, label:"Black Hills seized, treaty abandoned after gold found"),
        BlockEvent(year:1871, label:"End of treaty era, tribes no longer recognized as sovereign"),
        BlockEvent(year:1887, label:"Dawes Act, 90 million acres sold to white settlers"),
        BlockEvent(year:1890, label:"Wounded Knee, last military seizure of territory"),
        BlockEvent(year:1903, label:"Lone Wolf v. Hitchcock, treaty protections stripped"),
        BlockEvent(year:1934, label:"Allotment era ends, two thirds of land already gone"),
        BlockEvent(year:1953, label:"Termination Policy, 109 tribes stripped of recognition"),
    ]
}

struct TimelineEvent: Identifiable {
    let id: Int
    let year: Int
    let text: String
    let type: String

    var typeColor: Color {
        switch type {
        case "before":   return Color(hex: "#5C8A5E")!
        case "contact":  return Color(hex: "#8B7A4A")!
        case "removal":  return Color(hex: "#8B3A1E")!
        case "treaty":   return Color(hex: "#4A5C8B")!
        case "recovery": return Color(hex: "#5C8A5E")!
        default:         return T.gold
        }
    }

    static let all: [TimelineEvent] = [
        TimelineEvent(id:0,  year:1492, text:"An estimated 50 to 100 million Indigenous people live across the Americas. A population comparable to Europe at the time.", type:"before"),
        TimelineEvent(id:1,  year:1620, text:"Wampanoag people teach Pilgrim settlers to farm through their first winter. Within fifty years, King Philip's War ends Wampanoag sovereignty.", type:"contact"),
        TimelineEvent(id:2,  year:1776, text:"The United States declares independence on land belonging to hundreds of sovereign nations who were not consulted.", type:"contact"),
        TimelineEvent(id:3,  year:1803, text:"Louisiana Purchase. The U.S. buys 828,000 square miles from France, land France did not own.", type:"removal"),
        TimelineEvent(id:4,  year:1830, text:"Indian Removal Act. Signed by Andrew Jackson. Mandates forced removal of all eastern tribes west of the Mississippi.", type:"removal"),
        TimelineEvent(id:5,  year:1838, text:"Trail of Tears. 16,000 Cherokee are marched from their homeland. Four thousand die.", type:"removal"),
        TimelineEvent(id:6,  year:1851, text:"Fort Laramie Treaty acknowledges tribal territories on the Great Plains. It will be broken within twenty years.", type:"treaty"),
        TimelineEvent(id:7,  year:1864, text:"Sand Creek Massacre. 230 Cheyenne and Arapaho, mostly women, children and elders, are killed by U.S. troops.", type:"removal"),
        TimelineEvent(id:8,  year:1868, text:"Second Fort Laramie Treaty guarantees the Black Hills to the Lakota as long as rivers run and grass grows.", type:"treaty"),
        TimelineEvent(id:9,  year:1887, text:"Dawes Act breaks up communal tribal lands into individual allotments. Ninety million acres are seized and sold.", type:"removal"),
        TimelineEvent(id:10, year:1924, text:"Native Americans are granted U.S. citizenship. 148 years after the country was founded on their land.", type:"recovery"),
        TimelineEvent(id:11, year:1978, text:"American Indian Religious Freedom Act. Native peoples gain the legal right to practice their own traditions.", type:"recovery"),
        TimelineEvent(id:12, year:1980, text:"Supreme Court rules the Black Hills were illegally seized. The Lakota refuse the $106 million award. They want the land.", type:"recovery"),
        TimelineEvent(id:13, year:2024, text:"574 federally recognized tribes. 56 million acres of tribal land remain, less than 4 percent of original territory.", type:"present"),
    ]
}

struct Source: Identifiable {
    let id: Int
    let stat: String
    let source: String

    static let all: [Source] = [
        Source(id:0, stat:"1.5 Billion acres, original tribal land",   source:"Bureau of Indian Affairs, 2021 Land Area Report"),
        Source(id:1, stat:"56 Million acres remaining",                 source:"BIA, Trust Land and Restricted Status Summary, 2021"),
        Source(id:2, stat:"574 federally recognized tribes",            source:"Federal Register, Vol. 88, January 2023"),
        Source(id:3, stat:"9.7 Million Native Americans",               source:"U.S. Census Bureau, American Community Survey, 2020"),
        Source(id:4, stat:"150+ endangered languages",                  source:"Endangered Language Fund / UNESCO Atlas of World Languages in Danger"),
        Source(id:5, stat:"$2 billion unclaimed, Black Hills",          source:"United States v. Sioux Nation of Indians, 448 U.S. 371 (1980)"),
        Source(id:6, stat:"Territorial boundaries",                     source:"Native Land Digital, native-land.ca"),
        Source(id:7, stat:"Treaty records",                             source:"National Archives, Records of the Bureau of Indian Affairs, RG 75"),
        Source(id:8, stat:"Historical events",                          source:"Smithsonian National Museum of the American Indian"),
    ]
}
