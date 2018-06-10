package ru.togudev.coverdrawer.api

import java.util.*

data class Response(
        val users: Array<User>
) {

    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (javaClass != other?.javaClass) return false

        other as Response

        if (!Arrays.equals(users, other.users)) return false

        return true
    }

    override fun hashCode(): Int {
        return Arrays.hashCode(users)
    }

}