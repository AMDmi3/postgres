--
-- LLVM JIT related tests
--

SET jit_above_cost = 0;
SET jit_inline_above_cost = 0;
SET jit_optimize_above_cost = 0;

CREATE FUNCTION test_thread_local_storage_access()
    RETURNS int4
    AS '/dtmp/postgres/src/test/regress/regress.so' --, 'test_thread_local_storage_access'
    LANGUAGE C;

SELECT test_thread_local_storage_access();
SELECT test_thread_local_storage_access();
SELECT test_thread_local_storage_access();

-- both crash on FreeBSD as boolin() leads to TLS access through
-- isspace() which involves caching locale related data in TLS
SELECT (jsonb_array_elements('[true]'::jsonb)->>0)::boolean;
SELECT (case when random() >= 0.0 then 'true' else 'false' end)::boolean;

SET jit_above_cost to default;
SET jit_inline_above_cost to default;
SET jit_optimize_above_cost to default;

DROP FUNCTION test_thread_local_storage_access;
