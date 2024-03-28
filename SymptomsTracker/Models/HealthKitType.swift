import HealthKit
import SwiftData

// Source: https://developer.apple.com/documentation/healthkit/data_types/symptom_type_identifiers#3577503

enum TypeIdentifier: Codable {
    case abdominalCramps
    case bloating
    case constipation
    case diarrhea
    case heartburn
    case nausea
    case vomiting
    
    case appetiteChanges
    case chills
    case dizziness
    case fainting
    case fatigue
    case fever
    case generalizedBodyAche
    case hotFlashes
    
    case chestTightnessOrPain
    case coughing
    case rapidPoundingOrFlutteringHeartbeat
    case shortnessOfBreath
    case skippedHeartbeat
    case wheezing
    
    case lowerBackPain
    
    case headache
    case memoryLapse
    case moodChanges
    
    case lossOfSmell
    case lossOfTaste
    case runnyNose
    case soreThroat
    case sinusCongestion
    
    case breastPain
    case pelvicPain
    case vaginalDryness
    
    case acne
    case drySkin
    case hairLoss
    
    case nightSweats
    case sleepChanges
    case bladderIncontinence
}

// TODO: Get rid of TypeIdentifier if possible
let typeIdentifierMapping: [TypeIdentifier: HKCategoryTypeIdentifier] = [
    .abdominalCramps: .abdominalCramps,
    .bloating: .bloating,
    .constipation: .constipation,
    .diarrhea: .diarrhea,
    .heartburn: .heartburn,
    .nausea: .nausea,
    .vomiting: .vomiting,
    
    .appetiteChanges: .appetiteChanges,
    .chills: .chills,
    .dizziness: .dizziness,
    .fainting: .fainting,
    .fatigue: .fatigue,
    .fever: .fever,
    .generalizedBodyAche: .generalizedBodyAche,
    .hotFlashes: .hotFlashes,
    
    .chestTightnessOrPain: .chestTightnessOrPain,
    .coughing: .coughing,
    .rapidPoundingOrFlutteringHeartbeat: .rapidPoundingOrFlutteringHeartbeat,
    .shortnessOfBreath: .shortnessOfBreath,
    .skippedHeartbeat: .skippedHeartbeat,
    .wheezing: .wheezing,
    
    .lowerBackPain: .lowerBackPain,
    
    .headache: .headache,
    .memoryLapse: .memoryLapse,
    .moodChanges: .moodChanges,
    
    .lossOfSmell: .lossOfSmell,
    .lossOfTaste: .lossOfTaste,
    .runnyNose: .runnyNose,
    .soreThroat: .soreThroat,
    .sinusCongestion: .sinusCongestion,
    
    .breastPain: .breastPain,
    .pelvicPain: .pelvicPain,
    .vaginalDryness: .vaginalDryness,
    
    .acne: .acne,
    .drySkin: .drySkin,
    .hairLoss: .hairLoss,
    
    .nightSweats: .nightSweats,
    .sleepChanges: .sleepChanges,
    .bladderIncontinence: .bladderIncontinence,
]

enum HealthKitTypeCategory: Codable, CaseIterable {
    case abdominalAndGastrointestinal
    case constitutional
    case heartAndLung
    case musculoskeletal
    case neurological
    case noseAndThroat
    case reproduction
    case skinAndHair
    case sleep
    case urinary
}

@Model
final class HealthKitType: Identifiable {
    var id = UUID()
    var key: TypeIdentifier = TypeIdentifier.headache
    var name: String = ""
    var icon: String = ""
    var note: String? = nil
    var category: HealthKitTypeCategory = HealthKitTypeCategory.neurological
    var symptomRel: Symptom?
    
    init(
        key: TypeIdentifier,
        name: String,
        icon: String,
        note: String? = nil,
        category: HealthKitTypeCategory
    ) {
        self.key = key
        self.name = name
        self.icon = icon
        self.note = note
        self.category = category
    }
}

let HealthKitTypes = [
    // Abdominal and Gastrointestinal
    HealthKitType(
        key: .abdominalCramps,
        name: String(localized: "Abdominal cramps"), // Břišní křeče
        icon: "😫",
        category: .abdominalAndGastrointestinal
    ),
    HealthKitType(
        key: .bloating,
        name: String(localized: "Bloating"), // Nadýmání
        icon: "💨",
        category: .abdominalAndGastrointestinal
    ),
    HealthKitType(
        key: .constipation,
        name: String(localized: "Constipation"), // Zácpa
        icon: "🚦",
        category: .abdominalAndGastrointestinal
    ),
    HealthKitType(
        key: .diarrhea,
        name: String(localized: "Diarrhea"), // Průjem
        icon: "💩",
        category: .abdominalAndGastrointestinal
    ),
    HealthKitType(
        key: .nausea,
        name: String(localized: "Nausea"), // Nevolnost
        icon: "🤢",
        category: .abdominalAndGastrointestinal
    ),
    HealthKitType(
        key: .vomiting,
        name: String(localized: "Vomiting"), // Zvracení
        icon: "🤮",
        category: .abdominalAndGastrointestinal
    ),
    
    // Constitutional
    HealthKitType(
        key: .appetiteChanges,
        name: String(localized: "Appetite changes"), // Změny chuti k jídlu
        icon: "🤤",
        category: .constitutional
    ),
    HealthKitType(
        key: .chills,
        name: String(localized: "Chills"), // Zimnice
        icon: "🥶",
        category: .constitutional
    ),
    HealthKitType(
        key: .dizziness,
        name: String(localized: "Dizziness"), // Závratě
        icon: "😵‍💫",
        category: .constitutional
    ),
    HealthKitType(
        key: .fainting,
        name: String(localized: "Fainting"), // Mdloby
        icon: "🫨",
        category: .constitutional
    ),
    HealthKitType(
        key: .fatigue,
        name: String(localized: "Fatigue"), // Únava
        icon: "🥱",
        category: .constitutional
    ),
    HealthKitType(
        key: .fever,
        name: String(localized: "Fever"), // Horečka
        icon: "🤒",
        category: .constitutional
    ),
    HealthKitType(
        key: .generalizedBodyAche,
        name: String(localized: "Body ache"), // Bolest celého těla
        icon: "😖",
        category: .constitutional
    ),
    HealthKitType(
        key: .hotFlashes,
        name: String(localized: "Hot flashes"), // Návaly horka
        icon: "🥵",
        category: .constitutional
    ),
    
    // Heart and Lung
    HealthKitType(
        key: .chestTightnessOrPain,
        name: String(localized: "Chest tightness or pain"), // Tlak nebo bolest na hrudi
        icon: "😫",
        category: .heartAndLung
    ),
    HealthKitType(
        key: .coughing,
        name: String(localized: "Coughing"), // Kašel
        icon: "😷",
        category: .heartAndLung
    ),
    HealthKitType(
        key: .rapidPoundingOrFlutteringHeartbeat,
        name: String(localized: "Rapid pounding or fluttering heartbeat"), // Rychlé bušení srdce
        icon: "❤️",
        category: .heartAndLung
    ),
    HealthKitType(
        key: .shortnessOfBreath,
        name: String(localized: "Shortness of breath"), // Dušnost
        icon: "😮‍💨",
        category: .heartAndLung
    ),
    HealthKitType(
        key: .skippedHeartbeat,
        name: String(localized: "Skipped heartbeat"), // Vynechaný srdeční tep
        icon: "💔",
        category: .heartAndLung
    ),
    HealthKitType(
        key: .wheezing,
        name: String(localized: "Wheezing"), // Sípání
        icon: "🫁",
        category: .heartAndLung
    ),
    // Musculoskeletal
    HealthKitType(
        key: .lowerBackPain,
        name: String(localized: "Lower back pain"), // Bolest dolní části zad
        icon: "😩",
        category: .musculoskeletal
    ),
    // Neurological
    HealthKitType(
        key: .headache,
        name: String(localized: "Headache"), // Bolest hlavy
        icon: "🤯",
        category: .neurological
    ),
    HealthKitType(
        key: .memoryLapse,
        name: String(localized: "Memory lapse"), // Výpadek paměti
        icon: "🫥",
        category: .neurological
    ),
    HealthKitType(
        key: .moodChanges,
        name: String(localized: "Mood changes"), // Změny nálady
        icon: "🤬",
        category: .neurological
    ),
    // Nose and Throat
    HealthKitType(
        key: .lossOfSmell,
        name: String(localized: "Loss of smell"), // Ztráta čichu
        icon: "👃",
        category: .noseAndThroat
    ),
    HealthKitType(
        key: .lossOfTaste,
        name: String(localized: "Loss of taste"), // Ztráta chuti
        icon: "👅",
        category: .noseAndThroat
    ),
    HealthKitType(
        key: .runnyNose,
        name: String(localized: "Runny nose"), // Rýma
        icon: "🤧",
        category: .noseAndThroat
    ),
    HealthKitType(
        key: .soreThroat,
        name: String(localized: "Sore throat"), // Bolest krku
        icon: "😣",
        category: .noseAndThroat
    ),
    HealthKitType(
        key: .sinusCongestion,
        name: String(localized: "Sinus congestion"), // Zánět dutin
        icon: "😮‍💨",
        category: .noseAndThroat
    ),
    // Reproduction
    HealthKitType(
        key: .breastPain,
        name: String(localized: "Breast pain"), // Bolest prsou
        icon: "🍉",
        category: .reproduction
    ),
    HealthKitType(
        key: .pelvicPain,
        name: String(localized: "Pelvic pain"), // Bolest pánve
        icon: "🍑",
        category: .reproduction
    ),
    HealthKitType(
        key: .vaginalDryness,
        name: String(localized: "Vaginal dryness"), // Vaginální suchost
        icon: "🌵",
        category: .reproduction
    ),
    // Skin and Hair
    HealthKitType(
        key: .acne,
        name: String(localized: "Acne"), // Akné
        icon: "🫣",
        category: .skinAndHair
    ),
    HealthKitType(
        key: .drySkin,
        name: String(localized: "Dry skin"), // Suchá pokožka
        icon: "😶‍🌫️",
        category: .skinAndHair
    ),
    HealthKitType(
        key: .hairLoss,
        name: String(localized: "Hair loss"), // Vypadávání vlasů
        icon: "🤠",
        category: .skinAndHair
    ),
    // Sleep
    HealthKitType(
        key: .nightSweats,
        name: String(localized: "Night sweats"), // Noční pocení
        icon: "🥵",
        category: .sleep
    ),
    HealthKitType(
        key: .sleepChanges,
        name: String(localized: "Sleep changes"), // Změny spánku
        icon: "😴",
        category: .sleep
    ),
    // Urinary
    HealthKitType(
        key: .bladderIncontinence,
        name: String(localized: "Bladder incontinences"), // Inkontinence
        icon: "💦",
        category: .urinary
    ),
]
