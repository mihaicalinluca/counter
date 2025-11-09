#[test_only]
module counter::counter_tests;

use counter::counter::{Self, Counter};
use sui::clock;
use sui::test_scenario;

// test users
const OWNER: address = @0xA;
const RANDOM_USER: address = @0xB;

#[test]
fun test_create_counter_success() {
    let (mut scenario, clock) = setup();

    create_counter(&mut scenario, &clock);

    // verify counter was created and transferred to owner
    test_scenario::next_tx(&mut scenario, OWNER);
    {
        let counter = test_scenario::take_from_sender<Counter>(&scenario);

        // verify initial values
        assert!(counter::get_value(&counter) == 0, 0);
        assert!(counter::get_owner(&counter) == OWNER, 1);
        assert!(counter::get_timestamp(&counter) > 0, 2);

        test_scenario::return_to_sender(&scenario, counter);
    };

    clock::destroy_for_testing(clock);
    test_scenario::end(scenario);
}

#[test]
fun test_increment_success() {
    let (mut scenario, clock) = setup();

    create_counter(&mut scenario, &clock);

    test_scenario::next_tx(&mut scenario, OWNER);
    {
        let mut counter = test_scenario::take_from_address<Counter>(&scenario, OWNER);

        // this should pass
        counter::increment(&mut counter, test_scenario::ctx(&mut scenario));

        test_scenario::return_to_address(OWNER, counter);
    };

    clock::destroy_for_testing(clock);
    test_scenario::end(scenario);
}

#[test]
#[expected_failure(abort_code = counter::ENotOwner)]
fun test_increment_wrong_owner() {
    let (mut scenario, clock) = setup();

    create_counter(&mut scenario, &clock);

    test_scenario::next_tx(&mut scenario, RANDOM_USER);
    {
        let mut counter = test_scenario::take_from_address<Counter>(&scenario, OWNER);

        // this should abort with ENotOwner
        counter::increment(&mut counter, test_scenario::ctx(&mut scenario));

        test_scenario::return_to_address(OWNER, counter);
    };

    clock::destroy_for_testing(clock);
    test_scenario::end(scenario);
}

// utils
fun create_clock(scenario: &mut test_scenario::Scenario): clock::Clock {
    clock::create_for_testing(test_scenario::ctx(scenario))
}

fun setup(): (test_scenario::Scenario, clock::Clock) {
    let mut scenario = test_scenario::begin(OWNER);
    let clock = create_clock(&mut scenario);

    (scenario, clock)
}

fun create_counter(scenario: &mut test_scenario::Scenario, clock: &clock::Clock) {
    test_scenario::next_tx(scenario, OWNER);
    {
        counter::create_counter(clock, test_scenario::ctx(scenario));
    };
}
