#[allow(lint(public_entry))]
module counter::counter;

use sui::clock::Clock;
use sui::event;

////// error codes
const ENotOwner: u64 = 1;

////// data structures
public struct Counter has key {
    id: UID,
    owner: address,
    count: u64,
    timestamp: u64,
}

////// events
public struct CounterCreated has copy, drop {
    counter_id: ID,
    owner: address,
    timestamp: u64,
}

public struct CounterIncremented has copy, drop {
    counter_id: ID,
    new_value: u64,
}

////// endpoints
fun init(_ctx: &mut TxContext) {}

// create a new counter
public entry fun create_counter(clock: &Clock, ctx: &mut TxContext) {
    let counter_id = object::new(ctx);
    let counter_id_copy = object::uid_to_inner(&counter_id);
    let owner = tx_context::sender(ctx);

    let timestamp = sui::clock::timestamp_ms(clock);

    let counter = Counter {
        id: counter_id,
        owner,
        count: 0,
        timestamp,
    };

    // emit creation event
    event::emit(CounterCreated {
        counter_id: counter_id_copy,
        owner,
        timestamp,
    });

    // transfer the counter to the creator
    transfer::transfer(counter, owner);
}

// increment the counter
public entry fun increment(counter: &mut Counter, ctx: &TxContext) {
    // verify ownership
    assert!(counter.owner == tx_context::sender(ctx), ENotOwner);

    // move already handles overflow
    counter.count = counter.count + 1;

    // emit increment event
    event::emit(CounterIncremented {
        counter_id: object::uid_to_inner(&counter.id),
        new_value: counter.count,
    });
}

////// readonly
// get the current counter value
public fun get_value(counter: &Counter): u64 {
    counter.count
}

// get counter owner
public fun get_owner(counter: &Counter): address {
    counter.owner
}

// get counter creation timestamp
public fun get_timestamp(counter: &Counter): u64 {
    counter.timestamp
}
