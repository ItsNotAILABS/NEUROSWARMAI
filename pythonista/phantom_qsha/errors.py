"""
Phantom QSHA — Custom Exception Hierarchy.

Production-grade error types for clear failure categorization:
- PolicyError: Access policy violations (vault reads, privilege gates).
- IntegrityError: Tamper detection (receipt chain, commitment mismatches).
- ReplayError: Replay attack detection (duplicate wire IDs, expired TTLs).
"""

from __future__ import annotations


class PhantomError(Exception):
    """Base exception for all Phantom QSHA errors."""

    pass


class PolicyError(PhantomError):
    """Raised when a policy gate denies an operation.

    Examples:
        - Unauthorized vault read attempt.
        - Abstraction layer bypass attempt.
        - Insufficient privilege for private access.
    """

    pass


class IntegrityError(PhantomError):
    """Raised when cryptographic integrity verification fails.

    Examples:
        - Receipt chain hash mismatch (tamper detected).
        - Commitment verification failure.
        - Sealed receipt self-hash inconsistency.
    """

    pass


class ReplayError(PhantomError):
    """Raised when a replay attack is detected.

    Examples:
        - Duplicate wire_id reuse.
        - Expired TTL on shadow wire envelope.
        - Context key re-derivation attempt with stale context.
    """

    pass
