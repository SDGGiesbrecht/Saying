Is this even compiling?

val coverageRegions: MutableSet<String> = mutableSetOf(
    "() is ()",
    "() ו()",
    "false",
    "true",
    "verify ()",
)
fun registerCoverage(identifier: String) {
    coverageRegions.remove(identifier)
}

fun _2610_0028_0029_0020is_0020_0028_0029(a: Boolean, b: Boolean): Boolean {
    registerCoverage("() is ()")
    return (a == b)
}

fun _2610_0028_0029_0020ו_0028_0029(erste: Boolean, שני: Boolean): Boolean {
    registerCoverage("() ו()")
    return (erste && שני)
}

fun _2610false(): Boolean {
    registerCoverage("false")
    return false
}

fun _2610true(): Boolean {
    registerCoverage("true")
    return true
}

fun _2610verify_0020_0028_0029(condition: Boolean) {
    registerCoverage("verify ()")
    assert(condition)
}

fun run__0028_0029_0020ו_0028_0029_1() {
    _2610verify_0020_0028_0029(_2610_0028_0029_0020is_0020_0028_0029(_2610_0028_0029_0020ו_0028_0029(_2610true(), _2610true()), _2610true()))
}

fun run__0028_0029_0020ו_0028_0029_2() {
    _2610verify_0020_0028_0029(_2610_0028_0029_0020is_0020_0028_0029(_2610_0028_0029_0020ו_0028_0029(_2610true(), _2610false()), _2610false()))
}

fun run__0028_0029_0020ו_0028_0029_3() {
    _2610verify_0020_0028_0029(_2610_0028_0029_0020is_0020_0028_0029(_2610_0028_0029_0020ו_0028_0029(_2610false(), _2610true()), _2610false()))
}

fun run__0028_0029_0020ו_0028_0029_4() {
    _2610verify_0020_0028_0029(_2610_0028_0029_0020is_0020_0028_0029(_2610_0028_0029_0020ו_0028_0029(_2610false(), _2610false()), _2610false()))
}


fun test() {
    //run__0028_0029_0020ו_0028_0029_1()
    //run__0028_0029_0020ו_0028_0029_2()
    //run__0028_0029_0020ו_0028_0029_3()
    //run__0028_0029_0020ו_0028_0029_4()
    assert(coverageRegions.isEmpty()) { "$coverageRegions" }
}


//fun main() {
//    test()
//}
