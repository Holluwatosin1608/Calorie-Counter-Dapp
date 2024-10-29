import Buffer "mo:base/Buffer";
import Text "mo:base/Text";
import Time "mo:base/Time";

actor {
  type FoodEntry = {
    id: Nat;
    item: Text;
    calories: Nat;
    date: Time.Time;
    mealType: Text; // "Breakfast", "Lunch", "Dinner", "Snack"
  };

  var foodLog = Buffer.Buffer<FoodEntry>(0);

  public func addFoodEntry(item: Text, calories: Nat, mealType: Text) : async Nat {
    let id = foodLog.size();
    let newEntry: FoodEntry = {
      id;
      item;
      calories;
      date = Time.now();
      mealType;
    };
    foodLog.add(newEntry);
    id
  };

  public query func getDailyCalories(targetDate: Time.Time) : async Nat {
    var total = 0;
    let dayStart = targetDate - (targetDate % (24 * 60 * 60 * 1_000_000_000));
    let dayEnd = dayStart + (24 * 60 * 60 * 1_000_000_000);
    
    for (entry in foodLog.vals()) {
      if (entry.date >= dayStart and entry.date < dayEnd) {
        total += entry.calories;
      };
    };
    total
  };

  public query func getEntriesByMealType(mealType: Text) : async [FoodEntry] {
    let entries = Buffer.Buffer<FoodEntry>(0);
    for (entry in foodLog.vals()) {
      if (entry.mealType == mealType) {
        entries.add(entry);
      };
    };
    Buffer.toArray(entries)
  };

  public func deleteFoodEntry(id: Nat) : async Bool {
    if (id >= foodLog.size()) return false;
    let _ = foodLog.remove(id);
    true
  };
}