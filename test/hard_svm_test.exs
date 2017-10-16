defmodule HardSvmTest do
  use ExUnit.Case
  doctest HardSvm

  test "test transpose" do
    t_lst = [[1,2,3], [4,5,6], [7,8,9]]
    ans   = [[1,4,7], [2,5,8], [3,6,9]]
    assert HardSvm.transpose(t_lst) == ans
    assert HardSvm.transpose(ans) == t_lst
  end

  test "test dot 2 2" do
    lst1 = [[1,2,3], [4,5,6], [7,8,9]]
    lst2 = [[9,8,7], [6,5,4], [3,2,1]]
    ans1 = [[30,24,18],[84,69,54],[138,114,90]] # from numpy
    ans2 = [[90,114,138], [54,69,84], [18,24,30]] # from numpy

    assert lst1 |> HardSvm.dot(lst2) == ans1
    assert lst2 |> HardSvm.dot(lst1) == ans2
  end

  test "test dot 2, 1" do
    lst1 = [[1,2,3], [4,5,6], [7,8,9]]
    lst2 = [9,8,7]
    ans1 = [46,118,190]

    assert lst1 |> HardSvm.dot(lst2) == ans1
  end

  test "test dot 1, 2" do
    lst1 = [9,8,7]
    lst2 = [[1,2,3], [4,5,6], [7,8,9]]
    ans1 = [90,114,138]

    assert lst1 |> HardSvm.dot(lst2) == ans1
  end

  test "test dot 1, 1" do
    lst1 = [1,2,3]
    lst2 = [9,8,7]
    ans1 = 46

    assert lst1 |> HardSvm.dot(lst2) == ans1
  end

  test "test dot 0, 2" do
    lst1 = 10
    lst2 = [[1,2,3], [4,5,6], [7,8,9]]
    ans1 = [[10,20,30], [40,50,60], [70,80,90]]

    assert lst1 |> HardSvm.dot(lst2) == ans1
  end

  test "test dot 0, 1" do
    lst1 = 10
    lst2 = [9,8,7]
    ans1 = [90,80,70]

    assert lst1 |> HardSvm.dot(lst2) == ans1
  end

  test "test dot 0, 0" do
    lst1 = 10
    lst2 = 20
    ans1 = 200

    assert lst1 |> HardSvm.dot(lst2) == ans1
  end

  test "test mul 2, 2" do
    lst1 = [[1,2,3], [4,5,6], [7,8,9]]
    lst2 = [[9,8,7], [6,5,4], [3,2,1]]
    ans1 = [[9,16,21], [24,25,24], [21,16,9]] # from numpy

    assert lst1 |> HardSvm.mul(lst2) == ans1
  end

  test "test mul 1, 2" do
    lst1 = [9,8,7]
    lst2 = [[1,2,3], [4,5,6], [7,8,9]]
    ans1 = [[9,16,21],[36,40,42],[63,64,63]]

    assert lst1 |> HardSvm.mul(lst2) == ans1
  end

  test "test mul 1, 1" do
    lst1 = [1,2,3]
    lst2 = [9,8,7]
    ans1 = [9,16,21]

    assert lst1 |> HardSvm.mul(lst2) == ans1
  end

  test "test mul 0, 2" do
    lst1 = 10
    lst2 = [[1,2,3], [4,5,6], [7,8,9]]
    ans1 = [[10,20,30], [40,50,60], [70,80,90]]

    assert lst1 |> HardSvm.mul(lst2) == ans1
  end

  test "test mul 0, 1" do
    lst1 = 10
    lst2 = [9,8,7]
    ans1 = [90,80,70]

    assert lst1 |> HardSvm.mul(lst2) == ans1
  end

  test "test mul 0, 0" do
    lst1 = 10
    lst2 = 20
    ans1 = 200

    assert lst1 |> HardSvm.mul(lst2) == ans1
  end
end
