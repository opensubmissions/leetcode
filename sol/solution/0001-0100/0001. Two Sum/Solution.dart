class Solution {
  List<int> twoSum(List<int> nums, int target) {
    Map<int, int> map = {};
    for (int i = 0; i < nums.length; i++) {
      final int? complementIndex = map[target - nums[i]];
      if (complementIndex != null) {
        return [complementIndex, i];
      }
      map[nums[i]] = i;
    }
    return [];
  }
}